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

local cfg = vim.fn.stdpath("config"):gsub("\\", "/")
local base = (cfg:gsub("/nvim%-[^/]+$", "/nvim-base"))
if base == cfg then base = (cfg:gsub("/[^/]+$", "")) .. "/nvim-base" end
vim.opt.rtp:prepend(base)
package.path = base.."/lua/?.lua;"..base.."/lua/?/init.lua;"..package.path
vim.g.dotfiles_lazy_lockfile = base .. "/lazy-lock.json"

if vim.fn.has("nvim-0.12") == 1 then
	for _, path in ipairs(vim.api.nvim_get_runtime_file("parser/lua.*", true)) do
		if not path:gsub("\\", "/"):match("/nvim%-treesitter/") then
			pcall(vim.treesitter.language.add, "lua", { path = path })
			break
		end
	end
end

require("base")
