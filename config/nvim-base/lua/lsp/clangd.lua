local function is_list(l)
	if type(l) ~= "table" or l[1] == nil then
		return false
	end

	return true 
end

return function(clangd_arguments)
	local default_cmds = {
		"clangd",
		"--compile-commands-dir=build",
		"--background-index",
		"--function-arg-placeholders=false",
		"--header-insertion=never",
	}

	if is_list(clangd_arguments) then
		-- Extract flag names from defaults to avoid duplicates
		local default_flags = {}
		for _, cmd in ipairs(default_cmds) do
			local flag = cmd:match("^%-%-([^=]+)")
			if flag then
				default_flags[flag] = true
			end
		end
		
		-- Only add arguments from clangd_arguments if their flag isn't in defaults
		for _, arg in ipairs(clangd_arguments) do
			local flag = arg:match("^%-%-([^=]+)")
			if not flag or not default_flags[flag] then
				table.insert(default_cmds, arg)
			end
		end
	end

	vim.lsp.enable('clangd')
	vim.lsp.config('clangd', {
		cmd = default_cmds,
		filetypes = { "c", "cpp" },
		root_markers = { "CMakeLists.txt", ".git" },
		on_attach = function(client, bufnr)
			if client.server_capabilities.documentFormattingProvider then
				-- local grp = vim.api.nvim_create_augroup("LspFormat." .. bufnr, { clear = true })
				-- vim.api.nvim_create_autocmd("BufWritePre", {
				-- 	group = grp,
				-- 	buffer = bufnr,
				-- 	callback = function()
				-- 		vim.lsp.buf.format { async = false }
				-- 	end,
				-- })
			end

			local opts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
			vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
			vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
			vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
			vim.keymap.set('i', '(', function()
				vim.api.nvim_feedkeys('(', 'n', false)
				vim.defer_fn(function() vim.lsp.buf.signature_help() end, 0)
			end, opts)
		end,

		capabilities = require('cmp_nvim_lsp').default_capabilities(),
	})
end
