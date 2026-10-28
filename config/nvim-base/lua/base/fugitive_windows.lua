-- Neovim 0.12.6 can close Windows job pipes before all output reaches the
-- buffered options dictionary. Large concurrent diffs reproduce missing stdout
-- and truncated output. Use Fugitive's existing file-backed Vim job collector
-- for these helper jobs, while keeping Neovim job IDs, callbacks, and waits.
if vim.fn.exists('*fugitive#Execute') == 0 then
	vim.cmd.runtime('autoload/fugitive.vim')
end

local script_prefix
for _, script in ipairs(vim.fn.getscriptinfo()) do
	if script.name:gsub('\\', '/'):match('/autoload/fugitive%.vim$') then
		script_prefix = '<SNR>' .. script.sid .. '_'
	end
end
assert(script_prefix, 'Could not locate Fugitive job helpers')

-- These helpers are private upstream APIs. Leave a changed implementation
-- untouched and report the incompatibility when Fugitive is updated.
for _, signature in ipairs({
	'JobExecute(argv, jopts, stdin, callback, ...)',
	'JobVimExit(dict, callback, temp, job, status)',
}) do
	local name = signature:match('^[^(]+')
	local ok, definition = pcall(vim.fn.execute, 'function ' .. script_prefix .. name)
	if not ok or not definition:find(script_prefix .. signature, 1, true) then
		vim.notify('Fugitive job helpers changed. Review base/fugitive_windows.lua.', vim.log.levels.WARN)
		return
	end
end

-- Git for Windows provides sh.exe. Load arguments from a NUL-delimited file
-- to preserve their bytes and avoid shell command-line quoting limits.
local git_executable = vim.fs.normalize(vim.fn.exepath('git'))
local git_shell
for directory in vim.fs.parents(git_executable) do
	local candidate = directory .. '/usr/bin/sh.exe'
	if vim.fn.executable(candidate) == 1 then
		git_shell = candidate
		break
	end
end
if not git_shell then
	vim.notify('Fugitive Windows workaround requires Git for Windows: could not locate usr/bin/sh.exe.', vim.log.levels.WARN)
	return
end

local patch = [=[
function! @SID@DotfilesJobExit(dict, callback, temp, job, status, type) abort
  call delete(a:temp . '.args')
  call @SID@JobVimExit(a:dict, a:callback, a:temp, a:job, a:status)
endfunction

function! @SID@JobExecute(argv, jopts, stdin, callback, ...) abort
  let dict = a:0 ? a:1 : {}
  let cb = len(a:callback) ? a:callback : [function('len')]
  let temp = tempname()
  " Initialize both files so an interrupted job still has readable output.
  call writefile([], temp . '.out', 'b')
  call writefile([], temp . '.err', 'b')
  " writefile() encodes list separators as LF and embedded LF as NUL.
  " Keep newlines within arguments and terminate each argument with NUL.
  let argument_lines = ['']
  for argument in a:argv
    let argument_parts = split(argument, "\n", 1)
    let argument_lines[-1] .= remove(argument_parts, 0)
    call extend(argument_lines, argument_parts)
    let argument_lines[-1] .= "\n"
  endfor
  call writefile(argument_lines, temp . '.args', 'b')
  let script = 'out=$1; err=$2; args=$3; set --; ' .
        \ 'while IFS= read -r -d "" arg; do set -- "$@" "$arg"; done <"$args"; ' .
        \ 'exec "$@" >"$out" 2>"$err"'
  let argv = [@SHELL@, '-c', script, 'fugitive', temp . '.out', temp . '.err', temp . '.args']
  " Preserve the native Windows arguments when sh starts Git.
  let a:jopts.env = extend(copy(get(a:jopts, 'env', {})), {'MSYS2_ARG_CONV_EXCL': '*'})
  call extend(a:jopts, {'on_exit': function('@SID@DotfilesJobExit', [dict, cb, temp])})
  try
    let dict.job = jobstart(argv, a:jopts)
    if !empty(a:stdin)
      call chansend(dict.job, a:stdin)
    endif
    call chanclose(dict.job, 'stdin')
  catch /^Vim\%((\a\+)\)\=:E475:/
    call delete(temp . '.args')
    call delete(temp . '.out')
    call delete(temp . '.err')
    let [dict.exit_status, dict.stdout, dict.stderr] = [122, [''], ['']]
  endtry
  if empty(a:callback)
    call fugitive#Wait(dict)
  endif
  return dict
endfunction
]=]
patch = patch:gsub('@SID@', script_prefix)
patch = patch:gsub('@SHELL@', function() return vim.fn.string(git_shell) end)
vim.cmd(patch)
