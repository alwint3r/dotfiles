local luasnip_build = vim.fn.executable('make') == 1 and 'make install_jsregexp' or nil

local function telescope_fzf_build(plugin)
	if vim.fn.executable('cmake') == 0 then
		return
	end

	local function run(cmd)
		local result = vim.system(cmd, { cwd = plugin.dir, text = true }):wait()
		if result.code ~= 0 then
			error(table.concat(cmd, ' ') .. ' failed:\n' .. (result.stderr or result.stdout or ''))
		end
	end

	run({
		'cmake',
		'-S',
		'.',
		'-B',
		'build',
		'-DCMAKE_BUILD_TYPE=Release',
		'-DCMAKE_POLICY_VERSION_MINIMUM=3.5',
	})
	run({ 'cmake', '--build', 'build', '--config', 'Release' })

	if vim.fn.has('win32') == 1 then
		local expected = plugin.dir .. '/build/libfzf.dll'
		if vim.uv.fs_stat(expected) then
			return
		end

		for _, candidate in ipairs({
			plugin.dir .. '/build/Release/libfzf.dll',
			plugin.dir .. '/build/Debug/libfzf.dll',
			plugin.dir .. '/build/RelWithDebInfo/libfzf.dll',
			plugin.dir .. '/build/MinSizeRel/libfzf.dll',
		}) do
			if vim.uv.fs_stat(candidate) then
				vim.fn.mkdir(vim.fn.fnamemodify(expected, ':h'), 'p')
				local ok, err = vim.uv.fs_copyfile(candidate, expected)
				if not ok then
					error(('Failed to copy %s to %s: %s'):format(candidate, expected, err))
				end
				return
			end
		end
	end
end

return {
	{ 'folke/tokyonight.nvim' },
	{ 'nvim-lualine/lualine.nvim' },
	{ 'akinsho/bufferline.nvim', version = "*" },
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		---@module "ibl"
		opts = {},
	},
	{ 'wellle/targets.vim' },
	{ 'numToStr/Comment.nvim' },
	{ 'tpope/vim-surround' },
	{ 'kyazdani42/nvim-tree.lua' },
	{ 'nvim-lua/plenary.nvim' },
	{ 'nvim-telescope/telescope.nvim' },
	{ 'nvim-telescope/telescope-ui-select.nvim' },
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = telescope_fzf_build,
	},
	{ 'akinsho/toggleterm.nvim' },
	{ 'tpope/vim-fugitive' },
	{ 'lewis6991/gitsigns.nvim' },
	{ 'tpope/vim-repeat' },
	{ 'editorconfig/editorconfig-vim' },
	{ 'moll/vim-bbye' },
	-- {'folke/neoconf.nvim'},
	-- {'folke/neodev.nvim'},
	{ 'neovim/nvim-lspconfig' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-buffer' },
	{ 'hrsh7th/cmp-path' },
	{ 'L3MON4D3/LuaSnip',             build = luasnip_build },
	{ 'saadparwaiz1/cmp_luasnip' },
	{ 'rafamadriz/friendly-snippets' },
	{ 'isak102/telescope-git-file-history.nvim' },
	{ 'aaronhallaert/advanced-git-search.nvim' },
	{ 'tpope/vim-rhubarb' },
	{ 'iamcco/markdown-preview.nvim',
		cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
		build = "cd app && npm install && git restore .",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
}
