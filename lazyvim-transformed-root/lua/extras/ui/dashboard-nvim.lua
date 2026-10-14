-- Dependencies: Neovim 0.12.6; Git for vim.pack; dashboard-nvim; default Snacks picker and persistence; rg/fd for search.
-- Docs: https://github.com/nvimdev/dashboard-nvim
-- Enable: require("extras.ui.dashboard-nvim") in init.lua.
-- Set dashboard.enabled=false directly in plugins/snacks.lua. Choose one dashboard module.
-- Dropped: plugin-manager buttons/statistics and manager-window reopen events.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Initialize the Doom-style dashboard while retaining the editor statusline.
vim.pack.add({ "https://github.com/nvimdev/dashboard-nvim" })
require("dashboard").setup({
  theme = "doom",
  hide = { statusline = false },
  config = {
    header = { "", "", "N E O V I M", "", "" },
    -- Button actions call the configured picker/session plugins only when selected.
    center = {
      { action = "lua Snacks.picker.files()", desc = " Find file", icon = " ", key = "f" },
      { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
      { action = "lua Snacks.picker.recent()", desc = " Recent files", icon = " ", key = "r" },
      { action = "lua Snacks.picker.grep()", desc = " Find text", icon = " ", key = "g" },
      {
        action = "lua Snacks.picker.files({cwd=vim.fn.stdpath('config')})",
        desc = " Config",
        icon = " ",
        key = "c",
      },
      { action = "lua require('persistence').load()", desc = " Restore session", icon = " ", key = "s" },
      { action = "qa", desc = " Quit", icon = " ", key = "q" },
    },
    footer = { "Edit init.lua to customize your config" },
  },
})
