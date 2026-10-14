-- Dependencies: Neovim 0.12.6; Git for vim.pack; edgy.nvim; default Trouble/Noice/Snacks; optional sidebars configured by direct edits below.
-- Docs: https://github.com/folke/edgy.nvim
-- Enable: require("extras.ui.edgy") in init.lua.
-- Load after plugins/editor.lua/plugins/ui.lua. Directly add optional panes to this setup table; no other module changes it.
-- Conflicts: sidebars managed by their own layouts can compete; choose which windows Edgy owns.
-- Dropped: bufferline.offset monkey patch and automatic optional-plugin option injection.
-- For Telescope selection, set get_selection_window=function()require('edgy').goto_main();return 0 end directly in telescope.lua.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load pane management and retain screen positions while sidebars resize.
vim.pack.add({ "https://github.com/folke/edgy.nvim" })
vim.opt.splitkeep = "screen"
-- Place eligible tool windows along editor edges, leaving unrelated windows unmanaged.
require("edgy").setup({
  bottom = {
    {
      ft = "noice",
      size = { height = 0.4 },
      -- Manage split Noice windows only; floating popups retain their own layout.
      filter = function(_, win)
        return vim.api.nvim_win_get_config(win).relative == ""
      end,
    },
    { ft = "qf", title = "Quickfix" },
    {
      ft = "help",
      size = { height = 20 },
      -- Accept actual help buffers rather than every buffer carrying the help filetype.
      filter = function(buf)
        return vim.bo[buf].buftype == "help"
      end,
    },
    { title = "Neotest output", ft = "neotest-output-panel", size = { height = 15 } },
    {
      ft = "snacks_terminal",
      size = { height = 0.4 },
      -- Manage only bottom, editor-relative Snacks terminals with window metadata.
      filter = function(_, win)
        return vim.w[win].snacks_win
          and vim.w[win].snacks_win.position == "bottom"
          and vim.w[win].snacks_win.relative == "editor"
      end,
    },
    {
      ft = "trouble",
      -- Manage bottom Trouble splits, excluding its preview windows and other layouts.
      filter = function(_, win)
        return vim.w[win].trouble
          and vim.w[win].trouble.position == "bottom"
          and vim.w[win].trouble.type == "split"
          and not vim.w[win].trouble_preview
      end,
    },
  },
  -- Keep test summaries on the left and optional symbol/chat/task panes on explicit sides.
  left = {
    { title = "Neotest summary", ft = "neotest-summary" },
    -- { title = "Neo-tree", ft = "neo-tree", pinned = true, open = "Neotree show filesystem" },
  },
  right = {
    { title = "Grug Far", ft = "grug-far", size = { width = 0.4 } },
    -- { title = "Aerial", ft = "aerial", pinned = true, open = "AerialOpen" },
    -- { title = "Outline", ft = "Outline", pinned = true, open = "Outline" },
    -- { title = "Copilot Chat", ft = "copilot-chat", size = { width = 50 } },
    -- { title = "Overseer", ft = "OverseerList", open = function() require("overseer").open() end },
  },
  -- Resize the selected managed pane by two columns or rows with Ctrl-arrow keys.
  keys = {
    ["<C-Right>"] = function(win)
      win:resize("width", 2)
    end,
    ["<C-Left>"] = function(win)
      win:resize("width", -2)
    end,
    ["<C-Up>"] = function(win)
      win:resize("height", 2)
    end,
    ["<C-Down>"] = function(win)
      win:resize("height", -2)
    end,
  },
})
-- Toggle managed sidebars or select one to focus.
vim.keymap.set("n", "<leader>ue", function()
  require("edgy").toggle()
end, { desc = "Toggle sidebars" })
vim.keymap.set("n", "<leader>uE", function()
  require("edgy").select()
end, { desc = "Select sidebar" })
