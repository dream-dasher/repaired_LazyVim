-- Dependencies: oxlint + oxfmt (npm packages oxlint and oxfmt).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Parsers (install manually): none required.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Formatting ownership: choose Oxfmt OR Prettier/Biome for these filetypes.
-- Oxlint may duplicate ESLint diagnostics; choose ownership/rules explicitly.
-- Tools: https://oxc.rs/docs/guide/usage/oxlint.html ; https://oxc.rs/docs/guide/usage/formatter.html
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Enable Oxlint language diagnostics and fixes alongside the primary TS server.
vim.lsp.config("oxlint", {
  -- Try an Oxlint config at or above the Git root first, then search from the buffer.
  -- Only start a client when an Oxlint configuration is found.
  root_dir = function(buf, on_dir)
    local markers = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" }
    local git = vim.fs.root(buf, ".git")
    local root = git and vim.fs.root(git, markers) or vim.fs.root(buf, markers)
    if root then
      on_dir(root)
    end
  end,
  settings = { fixKind = "all" },
})
vim.lsp.enable("oxlint")
-- Conform owns formatting; do not enable the oxfmt LSP in parallel.
local conform = require("conform")
-- Assign Oxfmt as the formatter for supported web-language buffers.
for _, ft in ipairs({
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "json",
  "jsonc",
  "vue",
  "svelte",
  "astro",
}) do
  conform.formatters_by_ft[ft] = { "oxfmt" }
end
