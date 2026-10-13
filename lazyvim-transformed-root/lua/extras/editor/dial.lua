-- Dependencies: Neovim 0.12.6; Git for vim.pack; dial.nvim; no external executable.
-- Docs: https://github.com/monaqa/dial.nvim
-- Enable: require("extras.editor.dial") in init.lua.
-- Conflicts: replaces native Ctrl-a/Ctrl-x increment maps. Edit groups below to change recognized values.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/monaqa/dial.nvim" })
local augend = require("dial.augend")
local groups = {
  default = {
    augend.integer.alias.decimal,
    augend.integer.alias.decimal_int,
    augend.integer.alias.hex,
    augend.date.alias["%Y/%m/%d"],
    augend.constant.alias.en_weekday,
    augend.constant.alias.en_weekday_full,
    augend.constant.alias.bool,
    augend.constant.alias.Bool,
    augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
    augend.constant.new({
      elements = { "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth" },
      word = false,
      cyclic = true,
    }),
    augend.constant.new({
      elements = {
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      },
      word = true,
      cyclic = true,
    }),
  },
  typescript = { augend.constant.new({ elements = { "let", "const" } }) },
  css = { augend.hexcolor.new({ case = "lower" }), augend.hexcolor.new({ case = "upper" }) },
  vue = {
    augend.constant.new({ elements = { "let", "const" } }),
    augend.hexcolor.new({ case = "lower" }),
    augend.hexcolor.new({ case = "upper" }),
  },
  markdown = {
    augend.constant.new({ elements = { "[ ]", "[x]" }, word = false, cyclic = true }),
    augend.misc.alias.markdown_header,
  },
  json = { augend.semver.alias.semver },
  lua = { augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }) },
  python = { augend.constant.new({ elements = { "and", "or" } }) },
}
for name, group in pairs(groups) do
  if name ~= "default" then
    vim.list_extend(group, groups.default)
  end
end
require("dial.config").augends:register_group(groups)
local by_ft = {
  css = "css",
  sass = "css",
  scss = "css",
  vue = "vue",
  javascript = "typescript",
  typescript = "typescript",
  javascriptreact = "typescript",
  typescriptreact = "typescript",
  json = "json",
  lua = "lua",
  markdown = "markdown",
  python = "python",
}
for _, mode in ipairs({ "n", "x" }) do
  for _, mapping in ipairs({ { "<C-a>", "inc_" }, { "<C-x>", "dec_" }, { "g<C-a>", "inc_g" }, { "g<C-x>", "dec_g" } }) do
    vim.keymap.set(mode, mapping[1], function()
      return require("dial.map")[mapping[2] .. (mode == "x" and "visual" or "normal")](
        by_ft[vim.bo.filetype] or "default"
      )
    end, { expr = true, desc = "Increment/decrement value" })
  end
end
