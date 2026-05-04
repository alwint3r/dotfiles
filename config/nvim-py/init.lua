
local cfg = vim.fn.stdpath("config"):gsub("\\", "/")
local base = (cfg:gsub("/nvim%-[^/]+$", "/nvim-base"))
if base == cfg then
	base = (cfg:gsub("/[^/]+$", "")) .. "/nvim-base"
end

vim.opt.rtp:prepend(base)
package.path = base .. "/lua/?.lua;" .. base .. "/lua/?/init.lua;" .. package.path
vim.g.dotfiles_lazy_lockfile = base .. "/lazy-lock.json"

local lazypath = vim.fn.stdpath("data"):gsub("\\", "/") .. "/lazy/lazy.nvim"
local lazy_init = lazypath .. "/lua/lazy/init.lua"
if not vim.loop.fs_stat(lazy_init) then
	vim.fn.mkdir(vim.fn.fnamemodify(lazypath, ":h"), "p")
	local output = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		error("Failed to install lazy.nvim:\n" .. output)
	end
end

vim.opt.rtp:prepend(lazypath)

require("base")

vim.lsp.config('ty', {
	cmd = {
		"ty",
		"server",
	},
	filetypes = { "python" },
	root_markers = { "ty.toml", "pyproject.toml", "setup.py", ".git" },
	settings = {
		ty = {
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
vim.lsp.enable('ty')

-- Ruff formatter/LSP (uses `uv tool`-installed ruff)
vim.lsp.config('ruff', {
	cmd = { 'uv', 'tool', 'run', 'ruff', 'server' },
	filetypes = { 'python' },
	root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', 'setup.py', '.git' },
	on_attach = function(_, bufnr)
		local opts = { noremap = true, silent = true, buffer = bufnr }

		-- Ensure python formatting uses ruff when multiple LSP clients are attached.
		vim.keymap.set('n', '<leader>f', function()
			vim.lsp.buf.format({
				async = true,
				bufnr = bufnr,
				filter = function(c)
					return c.name == 'ruff'
				end,
			})
		end, opts)

	end,
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
})
vim.lsp.enable('ruff')
