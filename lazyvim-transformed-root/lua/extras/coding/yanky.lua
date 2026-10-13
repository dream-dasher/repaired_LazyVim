-- Dependencies: Neovim 0.12.6; Git for vim.pack; yanky.nvim; plenary.nvim; optional sqlite.lua + system SQLite library for persistent history.
-- Docs: https://github.com/gbprod/yanky.nvim
-- Enable: require("extras.coding.yanky") in init.lua.
-- Load after plugins/snacks.lua. Default history uses shada, avoiding a compiled SQLite dependency.
-- Conflicts: replaces p/P/gp/gP and several bracket mappings. Edit those keys directly if needed.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/gbprod/yanky.nvim",
})
require("yanky").setup({
  highlight = { timer = 150 },
  ring = { storage = "shada" },
  system_clipboard = { sync_with_ring = not vim.env.SSH_CONNECTION },
})
local map = vim.keymap.set
map({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank text" })
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put after" })
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put before" })
map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Put after leaving cursor" })
map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Put before leaving cursor" })
map("n", "[y", "<Plug>(YankyCycleForward)", { desc = "Cycle forward through yank history" })
map("n", "]y", "<Plug>(YankyCycleBackward)", { desc = "Cycle backward through yank history" })
map({ "n", "x" }, "<leader>p", function()
  Snacks.picker.yanky()
end, { desc = "Yank history" })
for key, plug in pairs({
  ["]p"] = "YankyPutIndentAfterLinewise",
  ["[p"] = "YankyPutIndentBeforeLinewise",
  ["]P"] = "YankyPutIndentAfterLinewise",
  ["[P"] = "YankyPutIndentBeforeLinewise",
  [">p"] = "YankyPutIndentAfterShiftRight",
  ["<p"] = "YankyPutIndentAfterShiftLeft",
  [">P"] = "YankyPutIndentBeforeShiftRight",
  ["<P"] = "YankyPutIndentBeforeShiftLeft",
  ["=p"] = "YankyPutAfterFilter",
  ["=P"] = "YankyPutBeforeFilter",
}) do
  map("n", key, "<Plug>(" .. plug .. ")", { desc = "Put with indentation" })
end
