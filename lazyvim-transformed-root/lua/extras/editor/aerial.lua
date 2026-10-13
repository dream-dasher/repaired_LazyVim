-- Dependencies: Neovim 0.12.6; Git for vim.pack; aerial.nvim; LSP with documentSymbol support or installed Tree-sitter parsers.
-- Docs: https://github.com/stevearc/aerial.nvim
-- Enable: require("extras.editor.aerial") in init.lua.
-- Load after plugins/editor.lua and config/keymaps.lua; replaces Trouble's <leader>cs.
-- Conflicts: outline.nvim also owns <leader>cs; choose one symbol sidebar.
-- Optional lualine: directly add {'aerial', sep=' ', depth=5} to plugins/ui.lua lualine_c.
-- Optional Edgy: directly add {title='Aerial',ft='aerial',pinned=true,open='AerialOpen'} to extras/ui/edgy.lua right.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/stevearc/aerial.nvim" })
local icons = vim.deepcopy(require("config.icons").kinds)
icons.lua = { Package = icons.Control }
require("aerial").setup({
  attach_mode = "global",
  backends = { "lsp", "treesitter", "markdown", "man" },
  show_guides = true,
  filter_kind = false,
  icons = icons,
  layout = {
    resize_to_content = false,
    win_opts = { winhl = "Normal:NormalFloat,FloatBorder:NormalFloat", signcolumn = "yes", statuscolumn = " " },
  },
  guides = { mid_item = "├╴", last_item = "└╴", nested_top = "│ ", whitespace = "  " },
})
vim.keymap.set("n", "<leader>cs", "<cmd>AerialToggle<cr>", { desc = "Symbols (Aerial)" })
-- If enabling Telescope, place its require before this module then uncomment:
-- require("telescope").load_extension("aerial")
-- vim.keymap.set("n", "<leader>ss", "<cmd>Telescope aerial<cr>", { desc = "Symbols (Aerial)" })
