-- Dependencies: Neovim 0.12.6; Git for vim.pack; neoconf.nvim; optional jsonc parser; no external executable.
-- Docs: https://github.com/folke/neoconf.nvim
-- Enable: require("extras.lsp.neoconf") in init.lua.
-- Optional project JSON settings reintroduce configuration layering; leave disabled if direct Lua edits suffice.
-- Legacy lspconfig setup interception is disabled: this config uses vim.lsp.config/enable.
-- To read settings explicitly, place this require BEFORE plugins/lsp.lua and add the commented before_init hook to the chosen native server config.
-- Dropped: automatic server interception/live reload. Restart the affected server after changing settings.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load project-setting access without automatic LSP interception or live reconfiguration.
vim.pack.add({ "https://github.com/folke/neoconf.nvim" })
require("neoconf").setup({
  live_reload = false,
  plugins = {
    lspconfig = { enabled = false },
    jsonls = { enabled = false },
    lua_ls = { enabled = false, enabled_for_neovim_config = false },
  },
})
-- Example direct edit inside vim.lsp.config("lua_ls", { ... }):
-- before_init = function(_, config)
--   config.settings = require("neoconf").get("lspconfig.lua_ls", config.settings or {}, { file = config.root_dir })
-- end,
