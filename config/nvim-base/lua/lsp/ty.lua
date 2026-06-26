-- Ty LSP for Python
vim.lsp.config("ty", {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	root_markers = { "ty.toml", "pyproject.toml", "setup.py", ".git" },
	settings = {
		ty = {},
	},
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.enable("ty")
