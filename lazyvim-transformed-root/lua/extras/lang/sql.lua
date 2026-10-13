-- Dependencies: SQL client for your DB (psql/mysql/sqlite3/sqlcmd/etc.); sqlfluff (pip/uv sqlfluff); configure your database connection manually.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim), plugins.linting (nvim-lint).
-- Plugins: tpope/vim-dadbod, kristijanhusak/vim-dadbod-ui, kristijanhusak/vim-dadbod-completion.
-- Parsers (install manually): sql.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- DB tools: https://github.com/tpope/vim-dadbod ; https://github.com/kristijanhusak/vim-dadbod-ui
-- Completion: https://github.com/kristijanhusak/vim-dadbod-completion ; https://docs.sqlfluff.com/
-- Queries run against real databases when requested; query-on-save is disabled.
-- SQL completion/table helpers query database metadata; use appropriately scoped credentials.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.g.omni_sql_default_compl_type = "syntax"
vim.g.loaded_sql_completion = true
local data = vim.fn.stdpath("data") .. "/dadbod_ui"
vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_save_location = data
vim.g.db_ui_tmp_query_location = data .. "/tmp"
vim.g.db_ui_show_database_icon = true
vim.g.db_ui_use_nerd_fonts = true
vim.g.db_ui_use_nvim_notify = true
vim.g.db_ui_execute_on_save = false
-- Example: vim.g.dbs = { dev = vim.env.DATABASE_URL }
-- Keep credentials in environment variables or an ignored private file.
vim.pack.add({
  { src = "https://github.com/tpope/vim-dadbod" },
  { src = "https://github.com/kristijanhusak/vim-dadbod-completion" },
  { src = "https://github.com/kristijanhusak/vim-dadbod-ui" },
})
vim.keymap.set("n", "<leader>D", "<cmd>DBUIToggle<cr>", { desc = "Toggle DBUI" })
local blink = require("blink.cmp")
blink.add_source_provider("dadbod", { name = "Dadbod", module = "vim_dadbod_completion.blink" })
local lint, conform = require("lint"), require("conform")
for _, ft in ipairs({ "sql", "mysql", "plsql" }) do
  blink.add_filetype_source(ft, "dadbod")
  lint.linters_by_ft[ft] = { "sqlfluff" }
  conform.formatters_by_ft[ft] = { "sqlfluff" }
end
conform.formatters.sqlfluff = { args = { "format", "--dialect=ansi", "-" } }
-- Change the dialect above or use your project's .sqlfluff configuration.
-- Optional Edgy: append { title="Database", ft="dbui", width=0.3, open=function() vim.cmd.DBUI() end }
-- to its right list and { title="DB Query Result", ft="dbout" } to its bottom list directly.
