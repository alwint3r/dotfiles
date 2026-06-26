-- sourcekit-lsp for Swift
if vim.fn.executable("sourcekit-lsp") == 0 and vim.fn.executable("xcrun") == 0 then
	return
end

vim.lsp.config("sourcekit", {
	cmd = vim.fn.has("mac") == 1
			and { "xcrun", "sourcekit-lsp" }
			or { "sourcekit-lsp" },
	filetypes = { "swift" },
	root_markers = {
		"Package.swift",
		"buildServer.json",
		".git",
	},
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.enable("sourcekit")
