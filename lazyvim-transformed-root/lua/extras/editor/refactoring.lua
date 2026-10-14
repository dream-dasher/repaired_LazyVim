-- Dependencies: Neovim 0.12.6; Git for vim.pack; refactoring.nvim; async.nvim; nvim-treesitter with parsers for supported languages.
-- Docs: https://github.com/ThePrimeagen/refactoring.nvim
-- Enable: require("extras.editor.refactoring") in init.lua.
-- Load after plugins/treesitter.lua; requires Neovim 0.12 APIs.
-- Conflicts: <leader>r prefix is used for refactors; edit the keys below if another extra needs it.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load syntax-aware refactoring and its async dependency.
vim.pack.add({
  "https://github.com/lewis6991/async.nvim",
  "https://github.com/ThePrimeagen/refactoring.nvim",
})
local refactor = require("refactoring")
refactor.setup({})
-- Select a refactor, or return the plugin's operator key sequence for inline/extract actions.
local map = vim.keymap.set
map({ "n", "x" }, "<leader>rs", function()
  refactor.select_refactor()
end, { desc = "Select refactor" })
map({ "n", "x" }, "<leader>ri", function()
  return refactor.inline_var()
end, { expr = true, desc = "Inline variable" })
map({ "n", "x" }, "<leader>rf", function()
  return refactor.extract_func()
end, { expr = true, desc = "Extract function" })
map({ "n", "x" }, "<leader>rF", function()
  return refactor.extract_func_to_file()
end, { expr = true, desc = "Extract function to file" })
map({ "n", "x" }, "<leader>rx", function()
  return refactor.extract_var()
end, { expr = true, desc = "Extract variable" })
-- Insert debug prints below the target; appended iw selects the variable under the cursor.
map("n", "<leader>rP", function()
  return require("refactoring.debug").print_loc({ output_location = "below" })
end, { expr = true, desc = "Debug print location" })
map({ "n", "x" }, "<leader>rp", function()
  return require("refactoring.debug").print_var({ output_location = "below" }) .. "iw"
end, { expr = true, desc = "Debug print variable" })
-- Return the cleanup operator followed by ag, selecting the whole buffer while restoring the view.
map("n", "<leader>rc", function()
  return require("refactoring.debug").cleanup({ restore_view = true }) .. "ag"
end, { expr = true, desc = "Remove debug prints" })
