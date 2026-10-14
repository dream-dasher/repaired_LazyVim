-- Dependencies: erl + erlang_ls (erlang_ls release; https://erlang-ls.github.io/getting-started/).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): erlang.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- The original Erlang LS choice is unmaintained; upstream recommends ELP as an alternative.
-- See https://github.com/erlang-ls/erlang_ls ; ELP: https://whatsapp.github.io/erlang-language-platform/
-- Erlang LS defaults to TCP, so the explicit --transport stdio argument is required.
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Start Erlang LS over stdio and scope projects by Erlang build markers.
vim.lsp.config("erlangls", {
  cmd = { "erlang_ls", "--transport", "stdio" },
  filetypes = { "erlang" },
  root_markers = { "rebar.config", "erlang.mk", ".git" },
})
vim.lsp.enable({ "erlangls" })
