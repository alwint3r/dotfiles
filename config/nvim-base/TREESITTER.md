# Tree-sitter Setup

This Neovim profile uses Neovim 0.12 built-in tree-sitter APIs and no longer uses the archived `nvim-treesitter` core plugin.

Non-bundled parsers and query files are installed explicitly with:

    config/nvim-base/bin/install-parsers

What the installer does:

- clones pinned grammar repositories into the `nvim-base` data directory cache
- builds parser binaries with `tree-sitter build`
- installs parser binaries into `stdpath('data')/site/parser`
- installs pinned query directories into `stdpath('data')/site/queries`

The pinned sources live in `config/nvim-base/treesitter-manifest.lua`.
