-- Dependencies: Neovim 0.12.6; Git for vim.pack; indent-blankline.nvim (ibl module); installed Tree-sitter parsers for scope.
-- Docs: https://github.com/lukas-reineke/indent-blankline.nvim
-- Enable: require("extras.ui.indent-blankline") in init.lua.
-- Set indent.enabled=false directly in plugins/snacks.lua before using this alternative.
-- Conflicts: choose one indent renderer. With mini-indentscope, set scope.enabled=false here.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Draw indentation/scope guides in editing buffers while excluding tool and dashboard filetypes.
vim.pack.add({ "https://github.com/lukas-reineke/indent-blankline.nvim" })
local ibl = require("ibl")
ibl.setup({
  indent = { char = "│", tab_char = "│" },
  scope = { show_start = false, show_end = false },
  exclude = {
    filetypes = {
      "Trouble",
      "alpha",
      "dashboard",
      "help",
      "neo-tree",
      "snacks_dashboard",
      "snacks_notif",
      "snacks_terminal",
      "snacks_win",
      "trouble",
    },
  },
})
-- Toggle guides for the current buffer without changing the global setup.
vim.keymap.set("n", "<leader>ug", function()
  ibl.setup_buffer(0, { enabled = not require("ibl.config").get_config(0).enabled })
end, { desc = "Toggle indent guides" })
