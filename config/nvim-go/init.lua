
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

local lsp = vim.lsp

local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true }

  -- LSP keybindings
  vim.keymap.set('n', 'gd', lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>rn', lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>f', function() lsp.buf.format({ async = true }) end, opts)
end

local gopls_defaults = {
  analyses = {
    unusedparams = true,
    unreachable = true,
  },
  staticcheck = false,
  gofumpt = true,
}

local function gopls_build_flags()
  local raw_flags = vim.env.GOPLS_BUILDFLAGS
  if not raw_flags or raw_flags == "" then
    return nil
  end

  local flags = vim.split(raw_flags, "%s+", { trimempty = true })
  if vim.tbl_isempty(flags) then
    return nil
  end

  return flags
end

local function apply_gopls_settings(config)
  config.settings = config.settings or {}
  config.settings.gopls = vim.tbl_deep_extend("force", {}, gopls_defaults)
  config.settings.gopls.buildFlags = gopls_build_flags()
end

local gopls_root_markers = { { "go.work", "go.mod" }, ".git" }

local function resolve_gopls_root(bufnr)
  bufnr = bufnr or 0
  local root = vim.fs.root(bufnr, gopls_root_markers)
  if root then
    return root
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  if name and name ~= "" then
    return vim.fs.dirname(name)
  end

  return vim.loop.cwd()
end

local function gopls_root_dir(bufnr, on_dir)
  local ok, root = pcall(resolve_gopls_root, bufnr)
  if ok then
    on_dir(root)
    return
  end

  vim.schedule(function()
    vim.notify(("gopls root detection failed: %s"):format(root), vim.log.levels.WARN)
  end)
  on_dir(vim.loop.cwd())
end

local gopls_config = {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = gopls_root_markers,
  on_attach = on_attach,
  root_dir = gopls_root_dir,
  on_new_config = function(config)
    apply_gopls_settings(config)
  end,
}

apply_gopls_settings(gopls_config)
vim.lsp.config('gopls', gopls_config)
vim.lsp.enable('gopls')

-- Diagnostic signs
vim.fn.sign_define('DiagnosticSignError', { text = '✘', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '▲', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = 'ⓘ', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '▶', texthl = 'DiagnosticSignHint' })

-- Show diagnostics in floating window on hover
vim.api.nvim_create_autocmd('CursorHold', {
  buffer = 0,
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' })
  end,
})

if os.getenv("CGO_ENABLED") == "1" then
	require("lsp.clangd")()
end
