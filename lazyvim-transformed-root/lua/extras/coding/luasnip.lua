-- Dependencies: Neovim 0.12.6; Git for vim.pack; LuaSnip; friendly-snippets. Optional C compiler/make + jsregexp for transformed snippets.
-- Docs: https://github.com/L3MON4D3/LuaSnip
-- Enable: require("extras.coding.luasnip") in init.lua.
-- Place this call BEFORE require("plugins.blink"); in plugins/blink.lua set snippets.preset = "luasnip".
-- Conflicts: replaces native vim.snippet; mutually exclusive with mini-snippets.
-- Manual optional build: review then run `make install_jsregexp` in the LuaSnip checkout; no build runs here.
-- For nvim-cmp, directly add cmp_luasnip and source = {name="luasnip"}, and use luasnip.lsp_expand.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Make LuaSnip and the shared VS Code-style snippet collection available.
vim.pack.add({
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/rafamadriz/friendly-snippets",
})
-- Retain snippet history and load the standard snippet collection immediately.
local snippets = require("luasnip")
snippets.config.setup({ history = true, delete_check_events = "TextChanged" })
require("luasnip.loaders.from_vscode").load()
-- Also load user snippets from the config directory when that directory exists.
local custom = vim.fn.stdpath("config") .. "/snippets"
if vim.uv.fs_stat(custom) then
  require("luasnip.loaders.from_vscode").load({ paths = { custom } })
end
-- Expand or jump forward only when a snippet action is available.
vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if snippets.expand_or_jumpable() then
    snippets.expand_or_jump()
  end
end, { desc = "Expand or jump snippet" })
-- Move to an earlier snippet field only when one exists.
vim.keymap.set({ "i", "s" }, "<C-h>", function()
  if snippets.jumpable(-1) then
    snippets.jump(-1)
  end
end, { desc = "Previous snippet field" })
