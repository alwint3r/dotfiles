-- rust-analyzer LSP for Rust
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
		if lsp.inlay_hint and lsp.inlay_hint.enable then
			pcall(lsp.inlay_hint.enable, true, { bufnr = bufnr })
		end
	end,
})

lsp.enable("rust_analyzer")
