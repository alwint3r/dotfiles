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

vim.keymap.set({ 'x', 'n' }, 'gy', '"+y')
vim.keymap.set({ 'x', 'n' }, 'gp', '"+p')

vim.keymap.set({ 'x', 'n' }, 'x', '"_x')
vim.keymap.set({ 'x', 'n' }, 'X', '"_d')

vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')


-- general plugin configurations

require("lazy").setup({
	spec = {
		{ import = "plugins.core" },
	},
	change_detection = { notify = false },
})

vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')

require('lualine').setup({
	options = {
		icons_enabled = true,
	}
})

require('bufferline').setup({})
vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', { silent = true })
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', { silent = true })

require('ibl').setup({})

require('nvim-treesitter.configs').setup({
	highlight = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
	},
	ensure_installed = {
		'c',
		'cpp',
		'cmake',
		'vim',
		'vimdoc',
		'lua',
		'javascript',
		'typescript',
		'tsx',
		'python',
	},
	modules = {},
	sync_install = false,
	ignore_install = {},
})
require('Comment').setup()

require('nvim-tree').setup({
	hijack_cursor = false,
	on_attach = function(bufnr)
		local bufmap = function(lhs, rhs, desc)
			vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
		end

		local api = require('nvim-tree.api')
		api.config.mappings.default_on_attach(bufnr)
		-- bufmap('L', api.node.open.edit, 'Expand folder or go to file')
		-- bufmap('H', api.node.navigate.parent_close, 'Close parent folder')
		-- bufmap('gh', api.tree.toggle_hidden_filter, 'Toggle hidden files')
	end
})

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')
vim.keymap.set('n', '<leader>ntf', '<cmd>NvimTreeFocus<cr>')

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
	},
})
require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')

-- Telescope Key Bindings
vim.keymap.set('n', '<leader><space>', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<leader>?', '<cmd>Telescope oldfiles<cr>')
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>') -- requires ripgrep
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>')
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope current_buffer_fuzzy_find<cr>')

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

-- Copilot & Copilot Chat
vim.g.copilot_enabled = 0
vim.g.copilot_no_tab_map = true
vim.g.copilot_filetypes = { ["*"] = false }
vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<S-Tab>")', { expr = true, silent = true, replace_keycodes = false })
