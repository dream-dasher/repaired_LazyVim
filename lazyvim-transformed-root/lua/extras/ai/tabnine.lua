-- Dependencies: Neovim 0.12.6; Git for vim.pack; cmp-tabnine; blink.compat for Blink (default) or nvim-cmp; manually installed Tabnine binary; curl/unzip or PowerShell for manual installer.
-- Docs: https://github.com/tzachar/cmp-tabnine
-- Enable: require("extras.ai.tabnine") in init.lua.
-- Place this module BEFORE plugins/blink.lua; add 'tabnine' to sources.default and provider shown below directly in that file.
-- Manual install: review then execute cmp-tabnine's install.sh (or install.ps1 on Windows) in its checkout. No installer/build hook runs here.
-- Authenticate/configure explicitly in Tabnine Hub per upstream docs. Conflicts: prefer one AI completion source.
-- For nvim-cmp: remove blink.compat lines and add {name='cmp_tabnine'} to extras/coding/nvim-cmp.lua's sources.
-- Dropped: automatic lualine source injection and percentage-menu wrapper.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Register the cmp compatibility layer before loading the Tabnine source.
vim.pack.add({ { src = "https://github.com/saghen/blink.compat", version = vim.version.range("2.x") } })
require("blink.compat").setup({})
-- Limit Tabnine context/results; the binary and completion-provider wiring remain manual.
vim.pack.add({ "https://github.com/tzachar/cmp-tabnine" })
require("cmp_tabnine.config"):setup({ max_lines = 1000, max_num_results = 3, sort = true })
-- Direct edit in plugins/blink.lua:
-- sources.default = { "lsp", "path", "snippets", "buffer", "tabnine" }
-- sources.providers.tabnine = {
--   name = "Tabnine", module = "blink.compat.source", score_offset = 100, async = true,
--   opts = { cmp_name = "cmp_tabnine" },
-- }
