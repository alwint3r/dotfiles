
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

local function clangd_args_from_env()
	local raw = vim.env.NVIM_CPP_CLANGD_ARGS or vim.env.CLANGD_ARGS
	if not raw or raw == "" then
		return nil
	end

	local args = vim.split(raw, "%s+", { trimempty = true })
	if vim.tbl_isempty(args) then
		return nil
	end

	return args
end

require("lsp.clangd")(clangd_args_from_env())

vim.keymap.set('n', '<leader>b', '<cmd>TermExec cmd="./build.sh"<cr>', { desc = 'Build project' })
vim.keymap.set('n', '<leader>r', '<cmd>TermExec cmd="./run.sh"<cr>', { desc = 'Run project' })
