-- Dependencies: node; twiggy-language-server (npm package twiggy-language-server); PHP; twigcs (Composer friendsoftwig/twigcs); twig-cs-fixer (Composer vincentlanglet/twig-cs-fixer).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim), plugins.linting (nvim-lint).
-- Parsers (install manually): twig.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Enable Twig template language support using the installed server definition.
vim.lsp.config("twiggy_language_server", {})
vim.lsp.enable({ "twiggy_language_server" })

-- Format Twig with twig-cs-fixer through the core formatting hooks.
local conform = require("conform")
conform.formatters_by_ft["twig"] = { "twig-cs-fixer" }

-- Run twigcs through the core lint hooks for Twig buffers.
local lint = require("lint")
lint.linters_by_ft["twig"] = { "twigcs" }
