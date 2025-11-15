-- redirect
vim.notify("Use NVIM_APPNAME profiles. Opening nvim-base", vim.log.levels.WARN)
vim.fn.setenv("NVIM_APPNAME", "nvim-base")
dofile((vim.fn.stdpath("config"):gsub("/nvim$", "/nvim-base")) .. "/init.lua")
