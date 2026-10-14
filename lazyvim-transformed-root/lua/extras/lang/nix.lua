-- Dependencies: nil (nil language server), nixfmt, statix (Nix packages nil, nixfmt, statix).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim), plugins.linting (nvim-lint).
-- Parsers (install manually): nix.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Tools: https://github.com/oxalica/nil ; https://github.com/nerdypepper/statix
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Enable nil for Nix language navigation, completion, and diagnostics.
vim.lsp.config("nil_ls", {})
vim.lsp.enable({ "nil_ls" })

-- Use nixfmt through the existing formatting hooks.
local conform = require("conform")
conform.formatters_by_ft["nix"] = { "nixfmt" }

-- Add Statix diagnostics through the core lint events.
local lint = require("lint")
lint.linters_by_ft["nix"] = { "statix" }
