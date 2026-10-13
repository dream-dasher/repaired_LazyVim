-- External dependencies: Git; ripgrep (rg) for grep/TODO search; fd recommended
-- for file finding (rg/find are fallbacks). gh plus authentication is needed only
-- for GitHub issue/PR pickers; lazygit only for the optional terminal Git UI.
-- Image previews are disabled: enabling them needs a supported terminal and the
-- tools described at https://github.com/folke/snacks.nvim/blob/main/docs/image.md.
-- Plugin dependencies: folke/snacks.nvim; Flash/Trouble enhance picker actions;
-- persistence.nvim supplies the dashboard's session action. Manual builds: none.
-- Docs: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
-- https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md
-- This is the single Snacks setup. To use another picker/explorer, edit it here
-- and replace the mappings below; optional modules do not select one implicitly.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.pack.add({ { src = "https://github.com/folke/snacks.nvim" } })
local snacks = require("snacks")
local root = require("util.root")

local function term_nav(direction)
  return function(terminal)
    if terminal:is_floating() then
      return "<C-" .. direction .. ">"
    end
    vim.schedule(function()
      vim.cmd.wincmd(direction)
    end)
  end
end

snacks.setup({
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  words = { enabled = true },
  image = { enabled = false },
  statuscolumn = { enabled = true },
  explorer = { enabled = true },
  terminal = {
    win = {
      keys = {
        nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
        nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
        nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
        nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
        hide_slash = { "<C-/>", "hide", desc = "Hide Terminal", mode = "t" },
        hide_underscore = { "<C-_>", "hide", desc = "which_key_ignore", mode = "t" },
      },
    },
  },
  picker = {
    enabled = true,
    win = {
      input = {
        keys = {
          ["<A-c>"] = { "toggle_cwd", mode = { "n", "i" } },
          ["<A-t>"] = { "trouble_open", mode = { "n", "i" } },
          ["<A-s>"] = { "flash", mode = { "n", "i" } },
          ["s"] = { "flash" },
        },
      },
    },
    actions = {
      toggle_cwd = function(picker)
        local project = root.get(picker.input.filter.current_buf)
        local cwd = vim.fs.normalize(vim.fn.getcwd())
        picker:set_cwd(picker:cwd() == project and cwd or project)
        picker:find()
      end,
      trouble_open = function(...)
        return require("trouble.sources.snacks").actions.trouble_open.action(...)
      end,
      flash = function(picker)
        require("flash").jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
              end,
            },
          },
          action = function(match)
            picker.list:_move(picker.list:row2idx(match.pos[1]), true, true)
          end,
        })
      end,
    },
  },
  dashboard = {
    enabled = true,
    preset = {
      header = "NEOVIM\nA standalone configuration",
      keys = {
        {
          icon = " ",
          key = "f",
          desc = "Find File",
          action = function()
            snacks.picker.files({ cwd = root.get() })
          end,
        },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        {
          icon = " ",
          key = "p",
          desc = "Projects",
          action = function()
            snacks.picker.projects()
          end,
        },
        {
          icon = " ",
          key = "g",
          desc = "Find Text",
          action = function()
            snacks.picker.grep({ cwd = root.get() })
          end,
        },
        {
          icon = " ",
          key = "r",
          desc = "Recent Files",
          action = function()
            snacks.picker.recent()
          end,
        },
        {
          icon = " ",
          key = "c",
          desc = "Config",
          action = function()
            snacks.picker.files({ cwd = vim.fn.stdpath("config") })
          end,
        },
        {
          icon = " ",
          key = "s",
          desc = "Restore Session",
          action = function()
            require("persistence").load()
          end,
        },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    -- A plain footer avoids lazy.nvim startup statistics and plugin management.
    sections = { { section = "header" }, { section = "keys", gap = 1, padding = 1 } },
  },
})

local map = vim.keymap.set
map("n", "<leader>,", function()
  snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>/", function()
  snacks.picker.grep({ cwd = root.get() })
end, { desc = "Grep (Root Dir)" })
map("n", "<leader>:", function()
  snacks.picker.command_history()
end, { desc = "Command History" })
map("n", "<leader><space>", function()
  snacks.picker.files({ cwd = root.get() })
end, { desc = "Find Files (Root Dir)" })
map("n", "<leader>n", function()
  snacks.picker.notifications()
end, { desc = "Notification History" })
map("n", "<leader>un", function()
  snacks.notifier.hide()
end, { desc = "Dismiss Notifications" })
map("n", "<leader>fb", function()
  snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fB", function()
  snacks.picker.buffers({ hidden = true, nofile = true })
end, { desc = "Buffers (all)" })
map("n", "<leader>fc", function()
  snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })
map("n", "<leader>ff", function()
  snacks.picker.files({ cwd = root.get() })
end, { desc = "Find Files (Root Dir)" })
map("n", "<leader>fF", function()
  snacks.picker.files({ cwd = vim.fn.getcwd() })
end, { desc = "Find Files (cwd)" })
map("n", "<leader>fg", function()
  snacks.picker.git_files({ cwd = root.get() })
end, { desc = "Find Files (git-files)" })
map("n", "<leader>fr", function()
  snacks.picker.recent()
end, { desc = "Recent" })
map("n", "<leader>fR", function()
  snacks.picker.recent({ filter = { cwd = true } })
end, { desc = "Recent (cwd)" })
map("n", "<leader>fp", function()
  snacks.picker.projects()
end, { desc = "Projects" })
map("n", "<leader>gd", function()
  snacks.picker.git_diff({ cwd = root.get() })
end, { desc = "Git Diff (hunks)" })
map("n", "<leader>gD", function()
  snacks.picker.git_diff({ cwd = root.get(), base = "origin", group = true })
end, { desc = "Git Diff (origin)" })
map("n", "<leader>gs", function()
  snacks.picker.git_status({ cwd = root.get() })
end, { desc = "Git Status" })
map("n", "<leader>gS", function()
  snacks.picker.git_stash({ cwd = root.get() })
end, { desc = "Git Stash" })
map("n", "<leader>gi", function()
  snacks.picker.gh_issue({ cwd = root.get() })
end, { desc = "GitHub Issues (open)" })
map("n", "<leader>gI", function()
  snacks.picker.gh_issue({ cwd = root.get(), state = "all" })
end, { desc = "GitHub Issues (all)" })
map("n", "<leader>gp", function()
  snacks.picker.gh_pr({ cwd = root.get() })
end, { desc = "GitHub Pull Requests (open)" })
map("n", "<leader>gP", function()
  snacks.picker.gh_pr({ cwd = root.get(), state = "all" })
end, { desc = "GitHub Pull Requests (all)" })
map("n", "<leader>sb", function()
  snacks.picker.lines()
end, { desc = "Buffer Lines" })
map("n", "<leader>sB", function()
  snacks.picker.grep_buffers()
end, { desc = "Grep Open Buffers" })
map("n", "<leader>sg", function()
  snacks.picker.grep({ cwd = root.get() })
end, { desc = "Grep (Root Dir)" })
map("n", "<leader>sG", function()
  snacks.picker.grep({ cwd = vim.fn.getcwd() })
end, { desc = "Grep (cwd)" })
map({ "n", "x" }, "<leader>sw", function()
  snacks.picker.grep_word({ cwd = root.get() })
end, { desc = "Selection / Word (Root Dir)" })
map({ "n", "x" }, "<leader>sW", function()
  snacks.picker.grep_word({ cwd = vim.fn.getcwd() })
end, { desc = "Selection / Word (cwd)" })
map("n", '<leader>s"', function()
  snacks.picker.registers()
end, { desc = "Registers" })
map("n", "<leader>s/", function()
  snacks.picker.search_history()
end, { desc = "Search History" })
map("n", "<leader>sa", function()
  snacks.picker.autocmds()
end, { desc = "Autocmds" })
map("n", "<leader>sc", function()
  snacks.picker.command_history()
end, { desc = "Command History" })
map("n", "<leader>sC", function()
  snacks.picker.commands()
end, { desc = "Commands" })
map("n", "<leader>sd", function()
  snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", "<leader>sD", function()
  snacks.picker.diagnostics_buffer()
end, { desc = "Buffer Diagnostics" })
map("n", "<leader>sh", function()
  snacks.picker.help()
end, { desc = "Help Pages" })
map("n", "<leader>sH", function()
  snacks.picker.highlights()
end, { desc = "Highlights" })
map("n", "<leader>si", function()
  snacks.picker.icons()
end, { desc = "Icons" })
map("n", "<leader>sj", function()
  snacks.picker.jumps()
end, { desc = "Jumps" })
map("n", "<leader>sk", function()
  snacks.picker.keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>sl", function()
  snacks.picker.loclist()
end, { desc = "Location List" })
map("n", "<leader>sM", function()
  snacks.picker.man()
end, { desc = "Man Pages" })
map("n", "<leader>sm", function()
  snacks.picker.marks()
end, { desc = "Marks" })
map("n", "<leader>sR", function()
  snacks.picker.resume()
end, { desc = "Resume" })
map("n", "<leader>sq", function()
  snacks.picker.qflist()
end, { desc = "Quickfix List" })
map("n", "<leader>su", function()
  snacks.picker.undo()
end, { desc = "Undotree" })
map("n", "<leader>uC", function()
  snacks.picker.colorschemes()
end, { desc = "Colorschemes" })

map("n", "<leader>fe", function()
  snacks.explorer({ cwd = root.get() })
end, { desc = "Explorer (Root Dir)" })
map("n", "<leader>fE", function()
  snacks.explorer({ cwd = vim.fn.getcwd() })
end, { desc = "Explorer (cwd)" })
map("n", "<leader>e", "<leader>fe", { desc = "Explorer (Root Dir)", remap = true })
map("n", "<leader>E", "<leader>fE", { desc = "Explorer (cwd)", remap = true })
map("n", "<leader>.", function()
  snacks.scratch()
end, { desc = "Toggle Scratch Buffer" })
map("n", "<leader>S", function()
  snacks.scratch.select()
end, { desc = "Select Scratch Buffer" })
map("n", "<leader>dps", function()
  snacks.profiler.scratch()
end, { desc = "Profiler Scratch Buffer" })
