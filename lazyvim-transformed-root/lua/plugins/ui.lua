-- External dependencies: none; a Nerd Font is recommended. Noice's rich LSP
-- documentation uses markdown/markdown_inline Treesitter parsers when installed.
-- Plugin dependencies: akinsho/bufferline.nvim, nvim-lualine/lualine.nvim,
-- folke/noice.nvim, MunifTanjim/nui.nvim; mini.icons, Snacks, Gitsigns and Trouble
-- are configured by earlier modules. Manual builds: none.
-- Docs: https://github.com/akinsho/bufferline.nvim#configuration
-- https://github.com/nvim-lualine/lualine.nvim#usage-and-customization
-- https://github.com/folke/noice.nvim#configuration
-- Noice owns messages/cmdline; its notifications use Snacks. Alternative status
-- lines or message UIs should replace the corresponding setup below explicitly.
-- Noice stores a log under stdpath('state'); no external commands run on setup.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.pack.add({
  { src = "https://github.com/akinsho/bufferline.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/folke/noice.nvim" },
})

local icons = require("config.icons")
local snacks = require("snacks")
local root = require("util.root")
local map = vim.keymap.set

require("bufferline").setup({
  highlights = (vim.g.colors_name or ""):find("catppuccin") and require("catppuccin.special.bufferline").get_theme()
    or nil,
  options = {
    close_command = function(buf)
      snacks.bufdelete(buf)
    end,
    right_mouse_command = function(buf)
      snacks.bufdelete(buf)
    end,
    diagnostics = "nvim_lsp",
    always_show_bufferline = false,
    diagnostics_indicator = function(_, _, diagnostics)
      return vim.trim(
        (diagnostics.error and icons.diagnostics.Error .. diagnostics.error .. " " or "")
          .. (diagnostics.warning and icons.diagnostics.Warn .. diagnostics.warning or "")
      )
    end,
    offsets = {
      { filetype = "neo-tree", text = "Neo-tree", highlight = "Directory", text_align = "left" },
      { filetype = "snacks_layout_box" },
    },
    get_element_icon = function(opts)
      return icons.ft[opts.filetype]
    end,
  },
})
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Toggle Pin" })
map("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", { desc = "Delete Non-Pinned Buffers" })
map("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Delete Buffers to the Right" })
map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Delete Buffers to the Left" })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous Buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous Buffer" })
map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("n", "[B", "<cmd>BufferLineMovePrev<cr>", { desc = "Move Buffer Previous" })
map("n", "]B", "<cmd>BufferLineMoveNext<cr>", { desc = "Move Buffer Next" })
map("n", "<leader>bj", "<cmd>BufferLinePick<cr>", { desc = "Pick Buffer" })

local symbols = require("trouble").statusline({
  mode = "symbols",
  groups = {},
  title = false,
  filter = { range = true },
  format = "{kind_icon}{symbol.name:Normal}",
  hl_group = "lualine_c_normal",
})
require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = vim.o.laststatus == 3,
    disabled_filetypes = { statusline = { "snacks_dashboard", "dashboard", "alpha", "ministarter" } },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {
      {
        function()
          return "󱉭 " .. vim.fs.basename(root.get())
        end,
      },
      {
        "diagnostics",
        symbols = {
          error = icons.diagnostics.Error,
          warn = icons.diagnostics.Warn,
          info = icons.diagnostics.Info,
          hint = icons.diagnostics.Hint,
        },
      },
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      {
        function()
          local filename = vim.api.nvim_buf_get_name(0)
          if filename == "" then
            return "[No Name]"
          end
          local path = vim.fs.relpath(root.get(), filename) or vim.fn.fnamemodify(filename, ":~")
          return path .. (vim.bo.modified and " [+]" or "") .. (vim.bo.readonly and " " or "")
        end,
      },
      {
        symbols.get,
        cond = function()
          return vim.g.trouble_lualine ~= false and vim.b.trouble_lualine ~= false and symbols.has()
        end,
      },
    },
    lualine_x = {
      snacks.profiler.status(),
      {
        function()
          return require("noice").api.status.command.get()
        end,
        cond = function()
          return require("noice").api.status.command.has()
        end,
        color = function()
          return { fg = snacks.util.color("Statement") }
        end,
      },
      {
        function()
          return require("noice").api.status.mode.get()
        end,
        cond = function()
          return require("noice").api.status.mode.has()
        end,
        color = function()
          return { fg = snacks.util.color("Constant") }
        end,
      },
      {
        function()
          return " " .. require("dap").status()
        end,
        cond = function()
          return package.loaded["dap"] and require("dap").status() ~= ""
        end,
        color = function()
          return { fg = snacks.util.color("Debug") }
        end,
      },
      {
        "diff",
        symbols = {
          added = icons.git.added,
          modified = icons.git.modified,
          removed = icons.git.removed,
        },
        source = function()
          local status = vim.b.gitsigns_status_dict
          if status then
            return { added = status.added, modified = status.changed, removed = status.removed }
          end
        end,
      },
    },
    lualine_y = {
      { "progress", separator = " ", padding = { left = 1, right = 0 } },
      { "location", padding = { left = 0, right = 1 } },
    },
    lualine_z = {
      function()
        return " " .. os.date("%R")
      end,
    },
  },
  extensions = { "quickfix", "neo-tree", "fzf" },
})

local noice = require("noice")
noice.setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  views = { notify = { backend = "snacks" } },
  routes = {
    {
      filter = {
        event = "msg_show",
        any = {
          { find = "%d+L, %d+B" },
          { find = "; after #%d+" },
          { find = "; before #%d+" },
        },
      },
      view = "mini",
    },
  },
  presets = { bottom_search = true, command_palette = true, long_message_to_split = true },
})
map("c", "<S-Enter>", function()
  noice.redirect(vim.fn.getcmdline())
end, { desc = "Redirect Cmdline" })
map("n", "<leader>snl", function()
  noice.cmd("last")
end, { desc = "Noice Last Message" })
map("n", "<leader>snh", function()
  noice.cmd("history")
end, { desc = "Noice History" })
map("n", "<leader>sna", function()
  noice.cmd("all")
end, { desc = "Noice All" })
map("n", "<leader>snd", function()
  noice.cmd("dismiss")
end, { desc = "Dismiss All Messages" })
map("n", "<leader>snt", function()
  snacks.picker.noice()
end, { desc = "Noice Picker" })
map({ "i", "n", "s" }, "<C-f>", function()
  if not require("noice.lsp").scroll(4) then
    return "<C-f>"
  end
end, { silent = true, expr = true, desc = "Scroll Forward" })
map({ "i", "n", "s" }, "<C-b>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<C-b>"
  end
end, { silent = true, expr = true, desc = "Scroll Backward" })
