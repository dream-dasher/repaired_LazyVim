-- Dependencies: Neovim 0.12.6; Git for vim.pack; nvim-treesitter-context; installed Tree-sitter parsers.
-- Docs: https://github.com/nvim-treesitter/nvim-treesitter-context
-- Enable: require("extras.ui.treesitter-context") in init.lua.
-- Load after plugins/treesitter.lua. Context is independent of the symbol sidebar/statusline.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter-context" })
local context = require("treesitter-context")
context.setup({ mode = "cursor", max_lines = 3 })
vim.keymap.set("n", "<leader>ut", function()
  if context.enabled() then
    context.disable()
  else
    context.enable()
  end
end, { desc = "Toggle syntax context" })
