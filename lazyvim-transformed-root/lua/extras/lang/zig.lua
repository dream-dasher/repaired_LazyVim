-- Dependencies: zig; zls (Zig language server; https://github.com/zigtools/zls).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): zig.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Optional tests: enable extras.test.core; add https://github.com/lawrence-laz/neotest-zig
-- to its vim.pack.add list and require("neotest-zig") to its adapters table.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Enable ZLS language support for Zig buffers.
vim.lsp.config("zls", {})
vim.lsp.enable({ "zls" })
