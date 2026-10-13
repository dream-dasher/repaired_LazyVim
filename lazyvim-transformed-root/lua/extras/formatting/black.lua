-- Dependencies: python3; black (pip install black or uv tool install black).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Parsers (install manually): none required.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Enable AFTER extras.lang.python to replace Ruff formatting; Ruff diagnostics/actions can remain.
-- Black: https://black.readthedocs.io/en/stable/usage_and_configuration/the_basics.html
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

require("conform").formatters_by_ft.python = { "black" }
