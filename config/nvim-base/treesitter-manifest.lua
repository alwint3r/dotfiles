return {
	parser_output_dir = 'site/parser',
	query_output_dir = 'site/queries',
	cache_dir = 'treesitter-src',
	query_sources = {
		core = {
			repo = 'https://github.com/nvim-treesitter/nvim-treesitter.git',
			revision = '4916d6592ede8c07973490d9322f187e07dfefac',
		},
	},
	parsers = {
		{
			lang = 'cpp',
			repo = 'https://github.com/tree-sitter/tree-sitter-cpp.git',
			revision = '8b5b49eb196bec7040441bee33b2c9a4838d6967',
		},
		{
			lang = 'cmake',
			repo = 'https://github.com/uyha/tree-sitter-cmake.git',
			revision = 'c7b2a71e7f8ecb167fad4c97227c838439280175',
		},
		{
			lang = 'javascript',
			repo = 'https://github.com/tree-sitter/tree-sitter-javascript.git',
			revision = '58404d8cf191d69f2674a8fd507bd5776f46cb11',
		},
		{
			lang = 'typescript',
			repo = 'https://github.com/tree-sitter/tree-sitter-typescript.git',
			revision = '75b3874edb2dc714fb1fd77a32013d0f8699989f',
			subdir = 'typescript',
		},
		{
			lang = 'tsx',
			repo = 'https://github.com/tree-sitter/tree-sitter-typescript.git',
			revision = '75b3874edb2dc714fb1fd77a32013d0f8699989f',
			subdir = 'tsx',
		},
		{
			lang = 'python',
			repo = 'https://github.com/tree-sitter/tree-sitter-python.git',
			revision = '26855eabccb19c6abf499fbc5b8dc7cc9ab8bc64',
		},
		{
			lang = 'rust',
			repo = 'https://github.com/tree-sitter/tree-sitter-rust.git',
			revision = '77a3747266f4d621d0757825e6b11edcbf991ca5',
		},
	},
	queries = {
		core = {
			'cpp',
			'cmake',
			'javascript',
			'typescript',
			'tsx',
			'python',
			'rust',
			'ecma',
			'jsx',
		},
	},
}
