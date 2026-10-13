-- External dependencies: Git for Gitsigns; ripgrep (rg) for GrugFar and TODO search.
-- Plugin dependencies: grug-far.nvim, flash.nvim, which-key.nvim, gitsigns.nvim,
-- trouble.nvim, todo-comments.nvim, plenary.nvim; Snacks provides TODO pickers.
-- Manual builds: none. Docs: https://github.com/MagicDuck/grug-far.nvim
-- https://github.com/folke/flash.nvim | https://github.com/folke/which-key.nvim
-- https://github.com/lewis6991/gitsigns.nvim | https://github.com/folke/trouble.nvim
-- https://github.com/folke/todo-comments.nvim
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/MagicDuck/grug-far.nvim" },
  { src = "https://github.com/folke/flash.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
})

local map = vim.keymap.set
require("grug-far").setup({ headerMaxWidth = 80 })
map({ "n", "x" }, "<leader>sr", function()
  local ext = vim.bo.buftype == "" and vim.fn.expand("%:e") or ""
  require("grug-far").open({
    transient = true,
    prefills = { filesFilter = ext ~= "" and "*." .. ext or nil },
  })
end, { desc = "Search and Replace" })

local flash = require("flash")
flash.setup({})
map({ "n", "x", "o" }, "s", function()
  flash.jump()
end, { desc = "Flash" })
map({ "n", "x", "o" }, "S", function()
  flash.treesitter()
end, { desc = "Flash Treesitter" })
map("o", "r", function()
  flash.remote()
end, { desc = "Remote Flash" })
map({ "o", "x" }, "R", function()
  flash.treesitter_search()
end, { desc = "Treesitter Search" })
map("c", "<C-s>", function()
  flash.toggle()
end, { desc = "Toggle Flash Search" })
map({ "n", "o", "x" }, "<C-space>", function()
  flash.treesitter({ actions = { ["<C-space>"] = "next", ["<BS>"] = "prev" } })
end, { desc = "Treesitter Incremental Selection" })

local wk = require("which-key")
wk.setup({
  preset = "helix",
  spec = {
    {
      mode = { "n", "x" },
      { "<leader><tab>", group = "tabs" },
      { "<leader>c", group = "code" },
      { "<leader>d", group = "debug" },
      { "<leader>dp", group = "profiler" },
      { "<leader>f", group = "file/find" },
      { "<leader>g", group = "git" },
      { "<leader>gh", group = "hunks" },
      { "<leader>q", group = "quit/session" },
      { "<leader>s", group = "search" },
      { "<leader>sn", group = "noice" },
      { "<leader>u", group = "ui" },
      { "<leader>x", group = "diagnostics/quickfix" },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "gs", group = "surround" },
      { "z", group = "fold" },
      {
        "<leader>b",
        group = "buffer",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        "<leader>w",
        group = "windows",
        proxy = "<C-w>",
        expand = function()
          return require("which-key.extras").expand.win()
        end,
      },
      { "gx", desc = "Open with system app" },
    },
  },
})
map("n", "<leader>?", function()
  wk.show({ global = false })
end, { desc = "Buffer Keymaps (which-key)" })
map("n", "<C-w><space>", function()
  wk.show({ keys = "<C-w>", loop = true })
end, { desc = "Window Hydra Mode" })

-- These are descriptions of mini.ai's actual mappings; no config selection layer.
for _, prefix in ipairs({ "a", "i", "an", "in", "al", "il" }) do
  for key, description in pairs({
    c = "class",
    d = "digits",
    e = "CamelCase / snake_case",
    f = "function",
    g = "entire file",
    o = "block / conditional / loop",
    t = "tag",
    u = "use / call",
    U = "call without dot",
  }) do
    wk.add({ { prefix .. key, desc = description, mode = { "o", "x" } } })
  end
end

local gs = require("gitsigns")
gs.setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },
  signs_staged = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
  },
  on_attach = function(buf)
    local function bmap(mode, lhs, rhs, description)
      map(mode, lhs, rhs, { buffer = buf, desc = description, silent = true })
    end
    bmap("n", "]h", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gs.nav_hunk("next")
      end
    end, "Next Hunk")
    bmap("n", "[h", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gs.nav_hunk("prev")
      end
    end, "Previous Hunk")
    bmap("n", "]H", function()
      gs.nav_hunk("last")
    end, "Last Hunk")
    bmap("n", "[H", function()
      gs.nav_hunk("first")
    end, "First Hunk")
    bmap({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
    bmap({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
    bmap("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
    bmap("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
    bmap("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
    bmap("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
    bmap("n", "<leader>ghb", function()
      gs.blame_line({ full = true })
    end, "Blame Line")
    bmap("n", "<leader>ghB", function()
      gs.blame()
    end, "Blame Buffer")
    bmap("n", "<leader>ghd", gs.diffthis, "Diff This")
    bmap("n", "<leader>ghD", function()
      gs.diffthis("~")
    end, "Diff This ~")
    bmap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Git Hunk")
  end,
})
map("n", "<leader>uG", function()
  gs.toggle_signs()
end, { desc = "Toggle Git Signs" })

local trouble = require("trouble")
trouble.setup({ modes = { lsp = { win = { position = "right" } } } })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols (Trouble)" })
map("n", "<leader>cS", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP Locations (Trouble)" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
map("n", "[q", function()
  if trouble.is_open() then
    trouble.prev({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cprev)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = "Previous Trouble / Quickfix Item" })
map("n", "]q", function()
  if trouble.is_open() then
    trouble.next({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cnext)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = "Next Trouble / Quickfix Item" })

local todo = require("todo-comments")
todo.setup({})
map("n", "]t", function()
  todo.jump_next()
end, { desc = "Next Todo Comment" })
map("n", "[t", function()
  todo.jump_prev()
end, { desc = "Previous Todo Comment" })
map("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "Todo (Trouble)" })
map(
  "n",
  "<leader>xT",
  "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
  { desc = "Todo / Fix / Fixme (Trouble)" }
)
map("n", "<leader>st", function()
  require("snacks").picker.todo_comments()
end, { desc = "Todo" })
map("n", "<leader>sT", function()
  require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
end, { desc = "Todo / Fix / Fixme" })
