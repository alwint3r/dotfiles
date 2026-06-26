-- TypeScript/JavaScript LSP
local lsp = vim.lsp

lsp.config("tsserver", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
	single_file_support = true,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

lsp.enable("tsserver")
