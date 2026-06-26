-- This profile has been consolidated into nvim-base.
local cfg = vim.fn.stdpath("config"):gsub("\\", "/")
local base = cfg:gsub("/nvim%-[^/]+$", "/nvim-base")
if base == cfg then
	base = (cfg:gsub("/[^/]+$", "")) .. "/nvim-base"
end
dofile(base .. "/init.lua")
