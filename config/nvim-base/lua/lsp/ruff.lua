-- Ruff formatter/LSP for Python
vim.lsp.config("ruff", {
	cmd = { "uv", "tool", "run", "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", "setup.py", ".git" },
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	on_attach = function(_, bufnr)
		local opts = { noremap = true, silent = true, buffer = bufnr }

		-- When multiple LSP clients are attached to a Python buffer,
		-- prefer Ruff for formatting.
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({
				async = true,
				bufnr = bufnr,
				filter = function(c)
					return c.name == "ruff"
				end,
			})
		end, opts)
	end,
})

vim.lsp.enable("ruff")
