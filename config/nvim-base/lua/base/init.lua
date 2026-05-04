vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.splitright = true

vim.keymap.set('n', '<space>w', '<cmd>write<cr>', { desc = 'Save' })

vim.g.mapleader = ','
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<leader>wq', '<cmd>write<bar>quit<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>quit<cr>')
vim.keymap.set('n', '<leader>yp', ':let @+=expand("%:p")<CR>', {
	noremap = true,
	silent = true,
	desc = "Copy file path",
})

vim.keymap.set({ 'x', 'n' }, 'gy', '"+y')
vim.keymap.set({ 'x', 'n' }, 'gp', '"+p')

vim.keymap.set({ 'x', 'n' }, 'x', '"_x')
vim.keymap.set({ 'x', 'n' }, 'X', '"_d')

vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')


-- general plugin configurations

local lazy_spec = {
	{ import = "plugins.core" },
}

-- Profiles can extend the base plugin set by declaring imports before
-- `require("base")`, instead of calling `lazy.setup()` a second time.
for _, import in ipairs(vim.g.dotfiles_lazy_imports or {}) do
	table.insert(lazy_spec, { import = import })
end

require("lazy").setup({
	spec = lazy_spec,
	lockfile = vim.g.dotfiles_lazy_lockfile,
	change_detection = { notify = false },
})

vim.opt.termguicolors = true
local theme = vim.env.NVIM_THEME_LIGHT == '1' and 'tokyonight-day' or 'tokyonight'
vim.cmd.colorscheme(theme)

local default_guicursor = vim.o.guicursor
local light_guicursor = table.concat({
	'n-v-c-sm:block-Cursor',
	'i-ci-ve:ver25-CursorInsert',
	'r-cr-o:hor20-Cursor',
	't:block-blinkon500-blinkoff500-TermCursor',
}, ',')

local function set_terminal_cursor_color(color)
	pcall(vim.api.nvim_ui_send, ('\27]12;%s\7'):format(color))
end

local function reset_terminal_cursor_color()
	pcall(vim.api.nvim_ui_send, '\27]112\7')
end

local function apply_light_theme_cursor()
	if vim.o.background == 'light' then
		vim.opt.guicursor = light_guicursor

		vim.api.nvim_set_hl(0, 'Cursor', { fg = '#e9e9ec', bg = '#1f2335' })
		vim.api.nvim_set_hl(0, 'CursorInsert', { fg = '#e9e9ec', bg = '#1f2335' })
		vim.api.nvim_set_hl(0, 'lCursor', { fg = '#e9e9ec', bg = '#1f2335' })
		vim.api.nvim_set_hl(0, 'CursorIM', { fg = '#e9e9ec', bg = '#1f2335' })

		set_terminal_cursor_color('#1f2335')
		return
	end

	vim.opt.guicursor = default_guicursor
	reset_terminal_cursor_color()
end

vim.api.nvim_create_autocmd('ColorScheme', {
	pattern = '*',
	callback = function()
		apply_light_theme_cursor()
	end,
})
vim.api.nvim_create_autocmd('OptionSet', {
	pattern = 'background',
	callback = function()
		apply_light_theme_cursor()
	end,
})
vim.api.nvim_create_autocmd('VimLeavePre', {
	callback = function()
		reset_terminal_cursor_color()
	end,
})
apply_light_theme_cursor()

require('lualine').setup({
	options = {
		icons_enabled = true,
		theme = theme,
	}
})

require('bufferline').setup({
	options = {
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				highlight = "Directory",
				separator = true,
			},
		},
	},
})
vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', { silent = true })
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', { silent = true })

require('ibl').setup({})

local function prefer_builtin_parser(lang)
	if vim.fn.has('nvim-0.12') == 0 then
		return
	end

	for _, path in ipairs(vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', true)) do
		if not path:match('/nvim%-treesitter/') then
			pcall(vim.treesitter.language.add, lang, { path = path })
			return
		end
	end
end

local function prefer_builtin_query(lang, query_group)
	if vim.fn.has('nvim-0.12') == 0 then
		return
	end

	local query_path = ('queries/%s/%s.scm'):format(lang, query_group)
	for _, path in ipairs(vim.api.nvim_get_runtime_file(query_path, true)) do
		if not path:match('/nvim%-treesitter/') then
			local ok, lines = pcall(vim.fn.readfile, path)
			if ok and lines and #lines > 0 then
				vim.treesitter.query.set(lang, query_group, table.concat(lines, '\n'))
				return
			end
		end
	end
end

local function prefer_pinned_query(lang, query_group, source)
	if vim.fn.has('nvim-0.12') == 0 then
		return
	end

	local path = ('%s/treesitter-src/%s/runtime/queries/%s/%s.scm')
		:format(vim.fn.stdpath('data'), source, lang, query_group)

	if vim.uv.fs_stat(path) == nil then
		return
	end

	local ok, lines = pcall(vim.fn.readfile, path)
	if ok and lines and #lines > 0 then
		vim.treesitter.query.set(lang, query_group, table.concat(lines, '\n'))
	end
end

local function ensure_builtin_parser_runtimepath()
	-- lazy.nvim can reset runtimepath and drop Neovim's libdir, while
	-- bundled parser binaries live under "<prefix>/lib/nvim/parser".
	if #vim.api.nvim_get_runtime_file('parser/markdown.*', false) > 0 then
		return
	end

	local candidates = {}
	local seen = {}

	local function add_candidate(path)
		if not path or path == '' or seen[path] then
			return
		end
		seen[path] = true
		table.insert(candidates, path)
	end

	local real_progpath = vim.uv.fs_realpath(vim.v.progpath) or vim.v.progpath
	if real_progpath and real_progpath ~= '' then
		local prefix_dir = vim.fs.dirname(vim.fs.dirname(real_progpath))
		add_candidate(prefix_dir .. '/lib/nvim')
	end

	if vim.env.VIMRUNTIME and vim.env.VIMRUNTIME ~= '' then
		local runtime_prefix = vim.fs.dirname(vim.fs.dirname(vim.env.VIMRUNTIME))
		add_candidate(runtime_prefix .. '/lib/nvim')
	end

	for _, runtime_path in ipairs(vim.api.nvim_list_runtime_paths()) do
		local runtime_prefix = runtime_path:match('^(.*)/share/nvim/runtime$')
		if runtime_prefix then
			add_candidate(runtime_prefix .. '/lib/nvim')
		end
	end

	for _, builtin_runtime in ipairs(candidates) do
		if vim.uv.fs_stat(builtin_runtime .. '/parser') then
			vim.opt.runtimepath:append(builtin_runtime)
			break
		end
	end
end

local function setup_treesitter()
	-- Install non-bundled parsers and pinned query files with
	-- `config/nvim-base/bin/install-parsers`.
	local parser_install_dir = vim.fn.stdpath('data') .. '/site'
	ensure_builtin_parser_runtimepath()

	-- Neovim 0.12 ships parsers for the languages used by hover markdown.
	-- Prefer them over any older nvim-treesitter copies to avoid
	-- parser/query mismatches in floating documentation buffers.
	for _, lang in ipairs({ 'lua', 'markdown', 'markdown_inline', 'vimdoc' }) do
		prefer_builtin_parser(lang)
	end
	for _, query in ipairs({
		{ 'lua', 'highlights' },
		{ 'lua', 'injections' },
		{ 'markdown', 'highlights' },
		{ 'markdown', 'injections' },
		{ 'markdown_inline', 'highlights' },
		{ 'markdown_inline', 'injections' },
		{ 'vimdoc', 'highlights' },
	}) do
		prefer_builtin_query(query[1], query[2])
	end

	-- The upstream tree-sitter-cpp grammar ships intentionally small
	-- highlights. Use the pinned nvim-treesitter query for richer C++ colors.
	prefer_pinned_query('cpp', 'highlights', 'nvim-treesitter')

	vim.opt.runtimepath:prepend(parser_install_dir)

	local group = vim.api.nvim_create_augroup('dotfiles-treesitter-highlight', { clear = true })
	vim.api.nvim_create_autocmd('FileType', {
		group = group,
		callback = function(args)
			if vim.bo[args.buf].filetype == 'markdown' and vim.bo[args.buf].buftype ~= '' then
				-- Hover/help markdown buffers can still pick up parser-query
				-- mismatches. Stop treesitter there instead of disabling
				-- markdown highlighting globally.
				vim.schedule(function()
					pcall(vim.treesitter.stop, args.buf)
				end)
				return
			end

			if vim.bo[args.buf].buftype ~= '' or vim.bo[args.buf].filetype == 'markdown' then
				return
			end

			pcall(vim.treesitter.start, args.buf)
		end,
	})
end

setup_treesitter()
require('Comment').setup()

require('nvim-tree').setup({
	hijack_cursor = false,
})

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')
vim.keymap.set('n', '<leader>ntf', '<cmd>NvimTreeFocus<cr>')
vim.keymap.set('n', '<leader>G', '<cmd>G<cr>')

local gfh_actions = require('telescope').extensions.git_file_history.actions

require('telescope').setup({
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = 'smart_case',
		},
		["ui-select"] = {
			require('telescope.themes').get_dropdown {}
		},
		["git_file_history"] = {
			mappings = {
				i = {
					["<leader>go"] = gfh_actions.open_in_browser,
				},
				n = {
					["<leader>go"] = gfh_actions.open_in_browser,
				}
			},
			browser_command = nil,
		},
		advanced_git_search = {},
	},
})
require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')
require('telescope').load_extension('git_file_history')
require('telescope').load_extension('advanced_git_search')

local telescope = require('telescope.builtin')

-- Telescope Key Bindings
vim.keymap.set('n', '<leader><space>', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<leader>?', '<cmd>Telescope oldfiles<cr>')
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
-- vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>') -- requires ripgrep
vim.keymap.set('n', '<leader>fg', function()
	telescope.live_grep({
		additional_args = function()
			return {
				"--hidden",
				"--no-ignore",
				"--no-ignore-parent",
			}
		end
	})
end, { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>')
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope current_buffer_fuzzy_find<cr>')
vim.keymap.set('n', '<leader>fe', '<cmd>Telescope lsp_document_symbols<cr>')
vim.keymap.set('n', '<leader>ds', '<cmd>Telescope lsp_document_symbols<cr>')
vim.keymap.set('n', '<leader>ws', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>')
vim.keymap.set('n', '<leader>gs', function()
	require('telescope').extensions.advanced_git_search.show_custom_functions()
end, { desc = 'Advanced Git Search' })

require('toggleterm').setup({
	open_mapping = '<C-g>',
	direction = 'horizontal',
	shade_terminal = true,
	on_open = function(term)
		local opts = { buffer = term.bufnr, noremap = true, silent = true }
		vim.keymap.set('t', '<S-C-x>', [[<C-\><C-n>]], opts)
		vim.keymap.set('t', '<S-C-h>', [[<C-\><C-n><C-W>h]], opts)
		vim.keymap.set('t', '<S-C-j>', [[<C-\><C-n><C-W>j]], opts)
		vim.keymap.set('t', '<S-C-k>', [[<C-\><C-n><C-W>k]], opts)
		vim.keymap.set('t', '<S-C-l>', [[<C-\><C-n><C-W>l]], opts)
	end,
})

vim.keymap.set('n', '<leader>ts', '<cmd>TermSelect<cr>')
vim.keymap.set('n', '<leader>tn', '<cmd>TermNew<cr>')

vim.lsp.config('lua_ls', {
	filetypes = { "lua" },
	root_markers = {
		".git",
		"init.lua",
		".luarc.json",
		".luarc.jsonc"
	},
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				globals = { 'vim' },
			},
		},
	},
})

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
	snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
	mapping = cmp.mapping.preset.insert({
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<C-e'] = cmp.mapping.abort(),
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'path' },
		{ name = 'buffer' },
	}),
	preselect = cmp.PreselectMode.Item,
	completion = { completeopt = 'menu,menuone,noinsert' },
})


vim.api.nvim_create_user_command('ReloadConfig', 'source $MYVIMRC', {})
vim.keymap.set('n', '<space><space>', '<cmd>Lexplore<cr>')

local augroup = vim.api.nvim_create_augroup('user_cmds', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'help', 'man' },
	group = augroup,
	desc = 'Use q to close the window',
	command = 'nnoremap <buffer> q <cmd>quit<cr>',
})

vim.api.nvim_create_autocmd('TextYankPost', {
	group = augroup,
	desc = 'Highlight on yank',
	callback = function(event)
		vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
	end
})

vim.api.nvim_create_autocmd('LspAttach', {
	group = augroup,
	desc = 'LSP keymaps',
	callback = function(event)
		local opts = { buffer = event.buf, noremap = true, silent = true }
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	end,
})

-- Common LSP
vim.keymap.set('n', '<leader>f', function()
	vim.lsp.buf.format { async = true }
end, { desc = 'Format file' })

vim.keymap.set('n', '<leader>d', function()
	vim.diagnostic.open_float(nil, {
		scope = "cursor",
		border = "rounded",
		source = "always",
	})
end, { desc = 'Show diagnostics' })

local html_capabilities = require('cmp_nvim_lsp').default_capabilities()
html_capabilities.textDocument = html_capabilities.textDocument or {}
html_capabilities.textDocument.completion = html_capabilities.textDocument.completion or {}
html_capabilities.textDocument.completion.completionItem = html_capabilities.textDocument.completion.completionItem or {}
html_capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config('html', {
	cmd = { 'vscode-html-language-server', '--stdio' },
	filetypes = { 'html' },
	root_markers = { 'package.json', '.git' },
	single_file_support = true,
	init_options = {
		provideFormatter = true,
		configurationSection = { 'html', 'css', 'javascript' },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
	},
	capabilities = html_capabilities,
})

vim.lsp.enable('html')

vim.lsp.config('sqruff', {
})

vim.lsp.enable('sqruff')

vim.filetype.add({
	extension = {
		wat = "wat",
		wast = "wat",
	},
})

vim.lsp.config("wat_lsp", {
	cmd = { "wat-lsp-rust" },
	filetypes = { "wat" },
	root_markers = { ".git" },
})

vim.lsp.enable("wat_lsp")
