
local cfg = vim.fn.stdpath("config")
local base = (cfg:gsub("/nvim%-[^/]+$", "/nvim-base"))
if base == cfg then
	base = (cfg:gsub("/[^/]+$", "")) .. "/nvim-base"
end

vim.opt.rtp:prepend(base)
package.path = base .. "/lua/?.lua;" .. base .. "/lua/?/init.lua;" .. package.path

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("base")

require("lazy").setup({
  spec = {
    { import = "plugins.core" },  -- from base
    { import = "plugins.lang" },  -- this profile
  },
  change_detection = { notify = false },
})

vim.lsp.enable('basedpyright')
vim.lsp.config('basedpyright', {
	cmd = {
		"basedpyright-langserver",
		"--stdio",
	},
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", ".git" },
	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
			}
		}
	},
	on_attach = function(client, bufnr)
		local opts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set('i', '(', function()
			vim.api.nvim_feedkeys('(', 'n', false)
			vim.defer_fn(function() vim.lsp.buf.signature_help() end, 0)
		end, opts)
	end,
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
})
