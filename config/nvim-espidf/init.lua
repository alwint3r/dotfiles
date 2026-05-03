
local cfg = vim.fn.stdpath("config"):gsub("\\", "/")
local base = (cfg:gsub("/nvim%-[^/]+$", "/nvim-base"))
if base == cfg then
	base = (cfg:gsub("/[^/]+$", "")) .. "/nvim-base"
end

vim.opt.rtp:prepend(base)
package.path = base .. "/lua/?.lua;" .. base .. "/lua/?/init.lua;" .. package.path
vim.g.dotfiles_lazy_lockfile = base .. "/lazy-lock.json"

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

local idf_path = os.getenv("IDF_TOOLS_PATH")
local query_driver = ""
if idf_path then
	query_driver = "--query-driver=" .. idf_path .. "/tools/xtensa-esp-elf/*/xtensa-esp-elf/bin/xtensa-esp*-elf-*"
else
	vim.notify("Can't get IDF_TOOLS_PATH environment. No query driver for clangd", vim.log.levels.WARN)
end

local clangd_args = {}
if query_driver ~= "" then
	clangd_args = { query_driver }
end

require("lsp.clangd")(clangd_args)

vim.keymap.set('n', '<leader>b', '<cmd>TermExec cmd="idf.py build"<cr>', { desc = 'Build project' })
vim.keymap.set('n', '<leader>fl', '<cmd>TermExec cmd="idf.py flash"<cr>', { desc = 'Flash project' })
vim.keymap.set('n', '<leader>mon', '<cmd>TermExec cmd="idf.py monitor"<cr>', { desc = 'Start monitor' })
vim.keymap.set('n', '<leader>moff', '<cmd>TermExec cmd="<C-]>"<cr>', { desc = 'Stop monitor' })
