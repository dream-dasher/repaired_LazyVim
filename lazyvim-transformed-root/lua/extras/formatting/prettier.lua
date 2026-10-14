-- Dependencies: node; prettier (npm prettier); framework-specific Prettier plugins in the project when needed.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Parsers (install manually): none required.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Formatting ownership: choose Prettier OR Biome/Oxfmt for shared filetypes.
-- Requiring a config makes Prettier opt-in per project. No startup external commands are run.
-- Config: https://prettier.io/docs/configuration ; https://github.com/stevearc/conform.nvim
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Choose whether Prettier requires a project config before it can format a buffer.
local conform = require("conform")
local require_config = false -- Edit directly to require a project Prettier config.
-- Assign Prettier as the formatter for these supported web/data filetypes.
for _, ft in ipairs({
  "css",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}) do
  conform.formatters_by_ft[ft] = { "prettier" }
end
-- Extend Conform's Prettier definition with an optional per-invocation config check.
conform.formatters.prettier = {
  -- Allow formatting immediately unless opt-in is required; then ask the nearest local binary
  -- (or PATH fallback) for this file's config and require a successful, nonempty response.
  condition = function(_, ctx)
    if not require_config then
      return true
    end
    -- Conform resolves project-local executable names before calling this formatter.
    local local_cmd = vim.fs.find("node_modules/.bin/prettier", { path = ctx.dirname, upward = true })[1]
    local result = vim.system({ local_cmd or "prettier", "--find-config-path", ctx.filename }, { text = true }):wait()
    return result.code == 0 and (result.stdout or ""):match("%S") ~= nil
  end,
}
