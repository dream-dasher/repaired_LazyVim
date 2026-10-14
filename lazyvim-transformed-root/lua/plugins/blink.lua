-- External dependencies: none. Uses Neovim's vim.snippet; no Rust build or binary download.
-- Plugin dependencies: saghen/blink.cmp (released 1.x), rafamadriz/friendly-snippets,
-- folke/lazydev.nvim (set up in plugins.coding). Manual builds: none with Lua fuzzy matching.
-- Docs: https://blink.cmp.saghen.dev/configuration/reference.html
-- Exclusive with nvim-cmp or another completion frontend. LuaSnip/mini.snippets require
-- changing snippets.preset here; friendly-snippets already supplies the native snippets.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Make Blink and the shared snippet collection available before configuring completion.
vim.pack.add({
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
})

-- Use Neovim snippets and Lua fuzzy matching, with LSP, paths, snippets and buffers as sources.
require("blink.cmp").setup({
  snippets = { preset = "default" },
  fuzzy = { implementation = "lua", prebuilt_binaries = { download = false } },
  appearance = {
    nerd_font_variant = "mono",
    kind_icons = require("config.icons").kinds,
  },
  -- Show documentation and ghost text; use Tree-sitter to highlight LSP completion entries.
  completion = {
    accept = { auto_brackets = { enabled = true } },
    menu = { draw = { treesitter = { "lsp" } } },
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    ghost_text = { enabled = true },
  },
  -- Add LazyDev's completion source in Lua buffers without replacing the usual sources.
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    per_filetype = { lua = { inherit_defaults = true, "lazydev" } },
    providers = {
      lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
    },
  },
  -- Complete command lines without preselecting an item or taking over arrow keys.
  cmdline = {
    enabled = true,
    keymap = { preset = "cmdline", ["<Right>"] = false, ["<Left>"] = false },
    completion = {
      list = { selection = { preselect = false } },
      menu = {
        -- Open the menu automatically for Ex commands, but leave searches unobstructed.
        auto_show = function()
          return vim.fn.getcmdtype() == ":"
        end,
      },
      ghost_text = { enabled = true },
    },
  },
  -- Enter accepts completion; Tab moves through snippet fields or keeps its usual behavior.
  keymap = {
    preset = "enter",
    ["<C-y>"] = { "select_and_accept" },
    ["<Tab>"] = { "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
  },
})
