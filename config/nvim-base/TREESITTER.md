# Tree-sitter Setup

This Neovim profile uses Neovim 0.12 built-in tree-sitter APIs and has no `nvim-treesitter` ecosystem dependencies.

Non-bundled parsers and query files are installed explicitly with:

    config/nvim-base/bin/install-parsers

What the installer does:

- clones pinned grammar repositories into the `nvim-base` data directory cache
- builds parser binaries with `tree-sitter build`
- installs parser binaries into `stdpath('data')/site/parser`
- installs grammar-bundled queries first (guaranteed parser compatibility)
- overlays additional queries from nvim-treesitter for missing query files

Query priority (grammar queries take precedence):
1. Grammar repo queries (e.g., `tree-sitter-python/queries/`)
2. nvim-treesitter queries (for any missing files)

The pinned sources live in `config/nvim-base/treesitter-manifest.lua`.