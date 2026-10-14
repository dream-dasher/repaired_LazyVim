-- Dependencies: Neovim 0.12.6; Git for vim.pack; neo-tree.nvim v3 branch; plenary.nvim; nui.nvim; default icon provider; Git for status.
-- Docs: https://github.com/nvim-neo-tree/neo-tree.nvim
-- Enable: require("extras.editor.neo-tree") in init.lua.
-- Set explorer.enabled=false directly in plugins/snacks.lua; load after core keymaps to replace <leader>e/E/fe/fE.
-- Conflicts: choose one default directory explorer (Snacks, Neo-tree, or mini.files).
-- Optional Edgy: add neo-tree panes directly to extras/ui/edgy.lua; no option injection occurs.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load Neo-tree v3 and its Lua UI dependencies.
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
})
local events = require("neo-tree.events")
--- Forward completed file moves/renames to Snacks so LSP clients can update their file references.
local function rename(data)
  Snacks.rename.on_rename_file(data.source, data.destination)
end
-- Configure filesystem, buffer, and Git views without replacing special editor panes.
require("neo-tree").setup({
  sources = { "filesystem", "buffers", "git_status" },
  open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline", "edgy" },
  filesystem = { bind_to_cwd = false, follow_current_file = { enabled = true }, use_libuv_file_watcher = true },
  window = {
    mappings = {
      l = "open",
      h = "close_node",
      ["<space>"] = "none",
      -- Copy the selected node's full identifier/path to the system clipboard.
      Y = {
        function(state)
          vim.fn.setreg("+", state.tree:get_node():get_id(), "c")
        end,
        desc = "Copy path",
      },
      -- Open the selected path in its associated system application.
      O = {
        function(state)
          vim.ui.open(state.tree:get_node().path)
        end,
        desc = "Open in system application",
      },
      P = { "toggle_preview", config = { use_float = false } },
    },
  },
  default_component_configs = {
    indent = {
      with_expanders = true,
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    git_status = { symbols = { unstaged = "󰄱", staged = "󰱒" } },
  },
  -- Send both move and rename notifications through the shared LSP file-rename helper.
  event_handlers = {
    { event = events.FILE_MOVED, handler = rename },
    { event = events.FILE_RENAMED, handler = rename },
  },
})
-- Toggle filesystem views at project root/cwd, plus separate Git-status and buffer sources.
local map = vim.keymap.set
map("n", "<leader>fe", function()
  require("neo-tree.command").execute({ toggle = true, dir = require("util.root").get() })
end, { desc = "Explorer (root)" })
map("n", "<leader>fE", function()
  require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
end, { desc = "Explorer (cwd)" })
map("n", "<leader>e", "<leader>fe", { remap = true, desc = "Explorer (root)" })
map("n", "<leader>E", "<leader>fE", { remap = true, desc = "Explorer (cwd)" })
map("n", "<leader>ge", function()
  require("neo-tree.command").execute({ source = "git_status", toggle = true })
end, { desc = "Git explorer" })
map("n", "<leader>be", function()
  require("neo-tree.command").execute({ source = "buffers", toggle = true })
end, { desc = "Buffer explorer" })
