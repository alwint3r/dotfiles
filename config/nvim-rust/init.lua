
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

lsp.config("rust_analyzer", {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json", ".git" },
	single_file_support = true,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
			},
			checkOnSave = true,
			check = {
				command = "clippy",
			},
		},
	},
	on_attach = function(_, bufnr)
		local opts = { noremap = true, silent = true, buffer = bufnr }

		vim.keymap.set("n", "gd", lsp.buf.definition, opts)
		vim.keymap.set("n", "K", lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", lsp.buf.implementation, opts)
		vim.keymap.set("n", "gr", lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>rn", lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>f", function()
			lsp.buf.format({ async = true })
		end, opts)

		if lsp.inlay_hint and lsp.inlay_hint.enable then
			pcall(lsp.inlay_hint.enable, true, { bufnr = bufnr })
		end
	end,
})

lsp.enable("rust_analyzer")
