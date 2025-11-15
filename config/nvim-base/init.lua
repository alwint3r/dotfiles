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

local cfg = vim.fn.stdpath("config")
local base = (cfg:gsub("/nvim%-[^/]+$", "/nvim-base"))
if base == cfg then base = (cfg:gsub("/[^/]+$", "")) .. "/nvim-base" end
vim.opt.rtp:prepend(base)
package.path = base.."/lua/?.lua;"..base.."/lua/?/init.lua;"..package.path

require("base")
