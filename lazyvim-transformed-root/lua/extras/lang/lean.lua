-- Dependencies: lean + lake from a manually installed Lean toolchain (elan); see https://lean-lang.org/lean4/doc/quickstart.html.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Plugins: Julian/lean.nvim; https://github.com/Julian/lean.nvim
-- Parsers (install manually): lean.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Single owner: lean.nvim starts leanls; do not enable an additional Lean LSP client.
-- Prepare toolchains/dependencies manually before editing; elan/lake may otherwise bootstrap them.
-- Current lean.nvim prevents dependency rebuilding on didOpen; commands can explicitly rebuild.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Set proof-editing UI, abbreviations, and progress display before plugin loading.
vim.g.lean_config = {
  mappings = true,
  abbreviations = { enable = true, leader = "\\", extra = { wknight = "♘" } },
  infoview = {
    autoopen = true,
    width = 50,
    height = 20,
    horizontal_position = "bottom",
    separate_tab = false,
    indicators = "auto",
  },
  progress_bars = { enable = true, character = "│", priority = 10 },
  stderr = { enable = true, height = 5 },
}
-- Current lean.nvim configures and enables the native leanls client itself.
-- Its LSP options now belong to vim.lsp.config rather than lean.setup().
vim.lsp.config("leanls", { init_options = { editDelay = 0, hasWidgets = true } })
vim.pack.add({ { src = "https://github.com/Julian/lean.nvim" } })
