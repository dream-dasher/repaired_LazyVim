-- External dependencies: none. Lua development features use lua-language-server
-- configured in plugins.lsp. Treesitter text objects require installed language parsers
-- and nvim-treesitter-textobjects (plugins.treesitter); comments fall back to native gc.
-- Plugin dependencies: nvim-mini/mini.pairs, nvim-mini/mini.ai, folke/ts-comments.nvim,
-- folke/lazydev.nvim. Manual builds: none.
-- Docs: https://nvim-mini.org/mini.nvim/doc/mini-pairs.html
-- https://nvim-mini.org/mini.nvim/doc/mini-ai.html
-- https://github.com/folke/ts-comments.nvim | https://github.com/folke/lazydev.nvim
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Load pairing, text objects, context-aware comments and Lua development support.
vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.pairs" },
  { src = "https://github.com/nvim-mini/mini.ai" },
  { src = "https://github.com/folke/ts-comments.nvim" },
  { src = "https://github.com/folke/lazydev.nvim" },
})

-- Insert matching delimiters in Insert mode and on the command line, but not in terminals.
local pairs = require("mini.pairs")
pairs.setup({ modes = { insert = true, command = true, terminal = false } })

-- Preserve the small useful LazyVim pairing rules here, where they can be edited
-- directly: don't pair inside strings, next to word characters, or before an
-- unmatched closer. Markdown's third backtick opens a fenced code block.
local open = pairs.open
--- Open a pair unless the surrounding text makes a single delimiter more appropriate.
--- Command-line input keeps Mini's behavior; parser errors fall back to the text checks.
pairs.open = function(pair, neigh_pattern)
  if vim.fn.getcmdtype() ~= "" then
    return open(pair, neigh_pattern)
  end
  local opener, closer = pair:sub(1, 1), pair:sub(2, 2)
  local line = vim.api.nvim_get_current_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local following = line:sub(cursor[2] + 1, cursor[2] + 1)
  local before = line:sub(1, cursor[2])
  -- A third backtick at the start of a Markdown line inserts the closing fence too.
  if opener == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
    return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
  end
  if following ~= "" and following:match([=[[%w%%%'%["%.%`%$]]=]) then
    return opener
  end
  -- Avoid inserting a closer inside a syntax-highlighted string when a parser is available.
  local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
  for _, capture in ipairs(ok and captures or {}) do
    if capture.capture == "string" then
      return opener
    end
  end
  -- Keep an existing excess closer instead of inserting another one immediately before it.
  if following == closer and closer ~= opener then
    local _, opening = line:gsub(vim.pesc(opener), "")
    local _, closing = line:gsub(vim.pesc(closer), "")
    if closing > opening then
      return opener
    end
  end
  return open(pair, neigh_pattern)
end
-- Toggle automatic pairing globally and report the new setting.
vim.keymap.set("n", "<leader>up", function()
  vim.g.minipairs_disable = not vim.g.minipairs_disable
  vim.notify("Auto pairs " .. (vim.g.minipairs_disable and "disabled" or "enabled"))
end, { desc = "Toggle Auto Pairs" })

-- Adjust native comment operators to the language at the cursor, including embedded code.
require("ts-comments").setup({})

-- Extend around/inside text objects with syntax constructs, tags, numbers and word segments.
local ai = require("mini.ai")
ai.setup({
  n_lines = 500,
  custom_textobjects = {
    -- Use parser captures for blocks, functions and classes, excluding delimiters for inside objects.
    o = ai.gen_spec.treesitter({
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
    -- Plain-text patterns cover paired tags, digit runs and CamelCase/snake_case word components.
    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
    d = { "%f[%d]%d+" },
    e = {
      { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
      "^().*()$",
    },
    -- Select the whole file; the inside variant trims blank lines at its edges.
    g = function(ai_type)
      local first, last = 1, vim.fn.line("$")
      if ai_type == "i" then
        first, last = vim.fn.nextnonblank(first), vim.fn.prevnonblank(last)
        -- An entirely blank file has no nonblank range, so select its first position.
        if first == 0 or last == 0 then
          return { from = { line = 1, col = 1 } }
        end
      end
      return { from = { line = first, col = 1 }, to = { line = last, col = math.max(#vim.fn.getline(last), 1) } }
    end,
    -- Match calls including dotted names, or just a simple word name with the uppercase variant.
    u = ai.gen_spec.function_call(),
    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
  },
})

-- Make library types available to Lua development when their corresponding names occur.
require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    { path = "snacks.nvim", words = { "Snacks" } },
    { path = "nvim-lspconfig", words = { "vim%.lsp%.config" } },
  },
})
