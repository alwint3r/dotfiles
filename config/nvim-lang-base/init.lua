
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
