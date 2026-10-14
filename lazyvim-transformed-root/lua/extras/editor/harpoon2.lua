-- Dependencies: Neovim 0.12.6; Git for vim.pack; harpoon (harpoon2 branch); plenary.nvim.
-- Docs: https://github.com/ThePrimeagen/harpoon/tree/harpoon2
-- Enable: require("extras.editor.harpoon2") in init.lua.
-- Load after config/keymaps.lua. Conflicts: <leader>1..9 may replace buffer selection mappings.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load the Harpoon v2 branch and its Lua dependency.
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
})
-- Fit the quick menu to the current window and save the list when toggling it.
local harpoon = require("harpoon")
harpoon:setup({ menu = { width = vim.api.nvim_win_get_width(0) - 4 }, settings = { save_on_toggle = true } })
-- Add the current file, inspect the list, or jump directly to one of its first nine entries.
vim.keymap.set("n", "<leader>H", function()
  harpoon:list():add()
end, { desc = "Harpoon file" })
vim.keymap.set("n", "<leader>h", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })
for index = 1, 9 do
  vim.keymap.set("n", "<leader>" .. index, function()
    harpoon:list():select(index)
  end, { desc = "Harpoon file " .. index })
end
