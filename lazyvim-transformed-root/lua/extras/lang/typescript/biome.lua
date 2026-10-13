-- Dependencies: biome (npm @biomejs/biome).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Parsers (install manually): none required.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Formatting ownership: choose Biome OR Prettier/Oxc for these filetypes.
-- Requires a biome.json/biome.jsonc project config. Biome LSP supplies diagnostics/actions; Conform formats.
-- Support matrix: https://biomejs.dev/internals/language-support/
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.lsp.config("biome", {})
vim.lsp.enable("biome")
local conform = require("conform")
for _, ft in ipairs({
  "astro",
  "css",
  "scss",
  "graphql",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "svelte",
  "typescript",
  "typescriptreact",
  "vue",
}) do
  conform.formatters_by_ft[ft] = { "biome-check" }
end
conform.formatters["biome-check"] = { require_cwd = true }
