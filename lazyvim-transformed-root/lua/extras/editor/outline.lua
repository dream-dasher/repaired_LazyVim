-- Dependencies: Neovim 0.12.6; Git for vim.pack; outline.nvim; LSP with documentSymbol support.
-- Docs: https://github.com/hedyhli/outline.nvim
-- Enable: require("extras.editor.outline") in init.lua.
-- Load after plugins/editor.lua and config/keymaps.lua; replaces Trouble's <leader>cs.
-- Conflicts: aerial.nvim owns the same key; choose one symbol sidebar.
-- Optional Edgy: add {title='Outline',ft='Outline',pinned=true,open='Outline'} directly to extras/ui/edgy.lua right.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load the symbol sidebar and combine shared kind icons with Outline's default highlights.
vim.pack.add({ "https://github.com/hedyhli/outline.nvim" })
local icons = {}
for kind, symbol in pairs(require("outline.config").defaults.symbols.icons) do
  icons[kind] = { icon = require("config.icons").kinds[kind] or symbol.icon, hl = symbol.hl }
end
-- Apply those icons and allow arrow keys to move through symbols and jump to their locations.
require("outline").setup({
  symbols = { icons = icons },
  keymaps = { up_and_jump = "<Up>", down_and_jump = "<Down>" },
})
-- Toggle Outline on the shared symbol-sidebar key.
vim.keymap.set("n", "<leader>cs", "<cmd>Outline<cr>", { desc = "Symbols (Outline)" })
