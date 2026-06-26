-- gopls LSP for Go
local function gopls_build_flags()
	local raw_flags = vim.env.GOPLS_BUILDFLAGS
	if not raw_flags or raw_flags == "" then
		return nil
	end

	local flags = vim.split(raw_flags, "%s+", { trimempty = true })
	if vim.tbl_isempty(flags) then
		return nil
	end

	return flags
end

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { { "go.work", "go.mod" }, ".git" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				unreachable = true,
			},
			staticcheck = false,
			gofumpt = true,
			buildFlags = gopls_build_flags(),
		},
	},
})

vim.lsp.enable("gopls")
