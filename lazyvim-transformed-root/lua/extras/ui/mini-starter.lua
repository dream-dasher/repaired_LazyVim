-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.starter; default Snacks picker and persistence; rg/fd for search.
-- Docs: https://github.com/nvim-mini/mini.starter
-- Enable: require("extras.ui.mini-starter") in init.lua.
-- Set dashboard.enabled=false directly in plugins/snacks.lua. Choose one dashboard module.
-- Dropped: plugin-manager items/statistics and manager-window lifecycle hooks.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/nvim-mini/mini.starter" })
local starter = require("mini.starter")
starter.setup({
  evaluate_single = true,
  header = "N E O V I M",
  items = {
    {
      name = "Find file",
      action = function()
        Snacks.picker.files()
      end,
      section = "Files",
    },
    { name = "New file", action = "ene | startinsert", section = "Files" },
    {
      name = "Recent files",
      action = function()
        Snacks.picker.recent()
      end,
      section = "Files",
    },
    {
      name = "Find text",
      action = function()
        Snacks.picker.grep()
      end,
      section = "Search",
    },
    {
      name = "Config",
      action = function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      section = "Config",
    },
    {
      name = "Restore session",
      action = function()
        require("persistence").load()
      end,
      section = "Session",
    },
    { name = "Quit", action = "qa", section = "Editor" },
  },
  content_hooks = { starter.gen_hook.adding_bullet("░ ", false), starter.gen_hook.aligning("center", "center") },
  footer = "Edit init.lua to customize your config",
})
