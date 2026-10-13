-- Dependencies: Neovim 0.12.6; Git for vim.pack; neogen; nvim-treesitter and installed parser for the current language.
-- Docs: https://github.com/danymat/neogen
-- Enable: require("extras.coding.neogen") in init.lua.
-- Load after plugins/treesitter.lua. Uses vim.snippet by default.
-- If using LuaSnip or mini-snippets, directly change snippet_engine below to 'luasnip' or 'mini'.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/danymat/neogen" })
require("neogen").setup({ snippet_engine = "nvim" })
vim.keymap.set("n", "<leader>cn", function()
  require("neogen").generate()
end, { desc = "Generate annotations" })
