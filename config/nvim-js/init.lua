
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

local telescope = require('telescope.builtin')
local lsp = vim.lsp

local function on_attach(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set('n', 'K', lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>rn', lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', lsp.buf.code_action, opts)

  vim.keymap.set('n', 'gd', telescope.lsp_definitions, opts)
  vim.keymap.set('n', 'gi', telescope.lsp_implementations, opts)
  vim.keymap.set('n', 'gr', telescope.lsp_references, opts)
end

local tsserver_root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }

local tsserver_config = {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_markers = tsserver_root_markers,
  single_file_support = true,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_attach = on_attach,
}

lsp.config('tsserver', tsserver_config)
lsp.enable('tsserver')
