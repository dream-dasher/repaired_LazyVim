-- Dependencies: Neovim 0.12.6; Git for vim.pack; alpha-nvim; default Snacks picker and persistence modules; rg/fd for search.
-- Docs: https://github.com/goolord/alpha-nvim
-- Enable: require("extras.ui.alpha") in init.lua.
-- Set dashboard.enabled=false in plugins/snacks.lua. Choose one of Snacks, Alpha, dashboard-nvim, mini-starter.
-- Dropped: plugin-manager buttons/statistics and reopening a manager window; dashboard keys call plugins directly.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load Alpha's dashboard template and replace its header and actions.
vim.pack.add({ "https://github.com/goolord/alpha-nvim" })
local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = { "", "N E O V I M", "" }
-- Open files/searches, create a buffer, restore a session, or quit on explicit button selection.
dashboard.section.buttons.val = {
  dashboard.button("f", "  Find file", "<cmd>lua Snacks.picker.files()<cr>"),
  dashboard.button("n", "  New file", "<cmd>ene | startinsert<cr>"),
  dashboard.button("r", "  Recent files", "<cmd>lua Snacks.picker.recent()<cr>"),
  dashboard.button("g", "  Find text", "<cmd>lua Snacks.picker.grep()<cr>"),
  dashboard.button("c", "  Config", "<cmd>lua Snacks.picker.files({cwd=vim.fn.stdpath('config')})<cr>"),
  dashboard.button("s", "  Restore session", "<cmd>lua require('persistence').load()<cr>"),
  dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
}
-- Add customization guidance and top padding, then initialize the dashboard.
dashboard.section.footer.val = "Edit init.lua to customize your config"
dashboard.opts.layout[1].val = 8
require("alpha").setup(dashboard.opts)
