-- Dependencies: julia; Julia packages LanguageServer and SymbolServer (install with Julia Pkg).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Plugins: kdheepak/cmp-latex-symbols + saghen/blink.compat v2 (Blink v1).
-- Manual Julia packages: julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add(["LanguageServer", "SymbolServer"])'
-- Parser (install manually): julia.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Julia LSP setup: https://github.com/julia-vscode/LanguageServer.jl
-- Optional latex-symbol completion: see the explicit Blink provider example below.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.lsp.config("julials", { settings = { julia = { completionmode = "qualify", lint = { missingrefs = "none" } } } })
vim.lsp.enable({ "julials" })

vim.pack.add({
  { src = "https://github.com/kdheepak/cmp-latex-symbols" },
  { src = "https://github.com/saghen/blink.compat", version = vim.version.range("2") },
})
require("blink.compat").setup({})
local blink = require("blink.cmp")
blink.add_source_provider("latex_symbols", {
  name = "latex_symbols",
  module = "blink.compat.source",
  async = true,
  opts = { strategy = 0 },
})
blink.add_filetype_source("julia", "latex_symbols")
