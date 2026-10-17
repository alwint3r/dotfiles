-- Use nvim-lspconfig's command, filetypes, and project root detection.
-- lazydev supplies Neovim and plugin types as they are needed.
vim.lsp.config("lua_ls", {
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
		},
	},
})

vim.lsp.enable("lua_ls")
