local source = debug.getinfo(1, 'S').source
local script_path = source:sub(1, 1) == '@' and source:sub(2) or source
local script_dir = vim.fs.dirname(script_path)
local config_dir = vim.fs.dirname(script_dir)
local manifest = dofile(config_dir .. '/treesitter-manifest.lua')

local data_dir = vim.fn.stdpath('data')
local site_dir = data_dir .. '/site'
local parser_dir = data_dir .. '/' .. manifest.parser_output_dir
local query_dir = data_dir .. '/' .. manifest.query_output_dir
local cache_dir = data_dir .. '/' .. manifest.cache_dir

local function info(msg)
	io.stdout:write(msg .. '\n')
end

local function fail(msg)
	io.stderr:write(msg .. '\n')
	vim.cmd('cquit 1')
end

local function ensure_dir(path)
	vim.fn.mkdir(path, 'p')
end

local function basename(url)
	return (url:gsub('/+$', ''):match('([^/]+)%.git$') or url:gsub('/+$', ''):match('([^/]+)$'))
end

local function run(cmd, cwd)
	local result = vim.system(cmd, {
		cwd = cwd,
		text = true,
	}):wait()
	if result.code ~= 0 then
		local parts = {
			('Command failed (%d): %s'):format(result.code, table.concat(cmd, ' ')),
		}
		if cwd then
			table.insert(parts, 'cwd: ' .. cwd)
		end
		if result.stdout and result.stdout ~= '' then
			table.insert(parts, 'stdout:\n' .. result.stdout)
		end
		if result.stderr and result.stderr ~= '' then
			table.insert(parts, 'stderr:\n' .. result.stderr)
		end
		fail(table.concat(parts, '\n'))
	end
	return result.stdout
end

local function path_exists(path)
	return vim.uv.fs_stat(path) ~= nil
end

local function path_type(path)
	local stat = vim.uv.fs_lstat(path)
	return stat and stat.type or nil
end

local function sync_repo(repo, revision)
	local repo_name = basename(repo)
	local repo_dir = cache_dir .. '/' .. repo_name
	if not path_exists(repo_dir) then
		info('Cloning ' .. repo)
		run({ 'git', 'clone', '--filter=blob:none', repo, repo_dir })
	else
		info('Fetching ' .. repo_name)
		run({ 'git', 'fetch', '--all', '--tags', '--prune' }, repo_dir)
	end

	info('Checking out ' .. repo_name .. ' at ' .. revision)
	run({ 'git', 'checkout', '--detach', revision }, repo_dir)
	return repo_dir
end

local function install_parser(entry)
	local repo_dir = sync_repo(entry.repo, entry.revision)
	local grammar_dir = repo_dir
	if entry.subdir then
		grammar_dir = repo_dir .. '/' .. entry.subdir
	end

	if not path_exists(grammar_dir .. '/grammar.js') and not path_exists(grammar_dir .. '/grammar.json') then
		fail('Missing grammar definition for ' .. entry.lang .. ' in ' .. grammar_dir)
	end

	local output = parser_dir .. '/' .. entry.lang .. '.so'
	info('Building parser ' .. entry.lang)
	run({ 'tree-sitter', 'build', '-o', output, grammar_dir })
end

local function copy_dir(src, dst)
	if not path_exists(src) then
		fail('Missing directory to copy: ' .. src)
	end
	vim.fn.delete(dst, 'rf')
	ensure_dir(vim.fs.dirname(dst))
	run({ 'cp', '-R', src, dst })
end

local function copy_into_dir(src, dst)
	if not path_exists(src) then
		fail('Missing directory to copy: ' .. src)
	end
	local dst_type = path_type(dst)
	if dst_type and dst_type ~= 'directory' then
		vim.fn.delete(dst, 'rf')
	end
	ensure_dir(dst)
	run({ 'cp', '-R', src .. '/.', dst })
end

local function install_queries(source_name, langs)
	local source = manifest.query_sources[source_name]
	local repo_dir = sync_repo(source.repo, source.revision)
	for _, lang in ipairs(langs) do
		local src = repo_dir .. '/runtime/queries/' .. lang
		if not path_exists(src) then
			src = repo_dir .. '/queries/' .. lang
		end
		local dst = query_dir .. '/' .. lang
		info(('Installing %s queries for %s'):format(source_name, lang))
		if source_name == 'core' then
			copy_dir(src, dst)
		else
			copy_into_dir(src, dst)
		end
	end
end

ensure_dir(site_dir)
ensure_dir(parser_dir)
ensure_dir(query_dir)
ensure_dir(cache_dir)

for _, entry in ipairs(manifest.parsers) do
	install_parser(entry)
end

for _, source_name in ipairs({ 'core', 'textobjects' }) do
	local langs = manifest.queries[source_name]
	if langs then
		install_queries(source_name, langs)
	end
end

info('Installed parsers to ' .. parser_dir)
info('Installed queries to ' .. query_dir)
vim.cmd('qa')
