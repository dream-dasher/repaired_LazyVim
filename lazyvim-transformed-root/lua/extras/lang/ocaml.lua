-- Dependencies: ocamllsp (opam package ocaml-lsp-server; https://github.com/ocaml/ocaml-lsp).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): ocaml.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Run Neovim in the desired opam switch environment (opam exec -- nvim).
-- Native root_markers uses filenames; the previous wildcard root matching is simplified to project markers.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.lsp.config("ocamllsp", {
  filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
  root_markers = { "dune-project", "dune-workspace", "esy.json", "package.json", ".git" },
})
vim.lsp.enable({ "ocamllsp" })
