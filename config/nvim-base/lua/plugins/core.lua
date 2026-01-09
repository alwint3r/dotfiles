
return {
	{ 'folke/tokyonight.nvim' },
	{ 'nvim-lualine/lualine.nvim' },
	{ 'akinsho/bufferline.nvim' },
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		---@module "ibl"
		opts = {},
	},
	{ 'nvim-treesitter/nvim-treesitter', branch = "master" },
	{ 'nvim-treesitter/nvim-treesitter-textobjects' },
	{ 'wellle/targets.vim' },
	{ 'numToStr/Comment.nvim' },
	{ 'tpope/vim-surround' },
	{ 'kyazdani42/nvim-tree.lua' },
	{ 'nvim-lua/plenary.nvim' },
	{ 'nvim-telescope/telescope.nvim' },
	{ 'nvim-telescope/telescope-ui-select.nvim' },
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build =
		'cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config Release',
	},
	{ 'akinsho/toggleterm.nvim' },
	{ 'tpope/vim-fugitive' },
	{ 'lewis6991/gitsigns.nvim' },
	{ 'tpope/vim-repeat' },
	{ 'editorconfig/editorconfig-vim' },
	{ 'moll/vim-bbye' },
	{ 'github/copilot.vim' },
	-- {'folke/neoconf.nvim'},
	-- {'folke/neodev.nvim'},
	{ 'neovim/nvim-lspconfig' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-buffer' },
	{ 'hrsh7th/cmp-path' },
	{ 'L3MON4D3/LuaSnip',             build = 'make install_jsregexp' },
	{ 'saadparwaiz1/cmp_luasnip' },
	{ 'rafamadriz/friendly-snippets' },
	{ 'CopilotC-Nvim/CopilotChat.nvim',
		branch = 'main',
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
		},
		build = 'make tiktoken',
		opts = {
			model = 'gpt-5',
			window = {
				layout = 'vertical'
			}
		},
	},
	{ 'isak102/telescope-git-file-history.nvim' },
	{ 'aaronhallaert/advanced-git-search.nvim' },
	{ 'tpope/vim-rhubarb' },
}
