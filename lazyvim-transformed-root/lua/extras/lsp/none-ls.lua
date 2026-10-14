-- Dependencies: Neovim 0.12.6; Git for vim.pack; none-ls.nvim; plenary.nvim; fish/fish_indent; stylua; shfmt installed on PATH.
-- Docs: https://github.com/nvimtools/none-ls.nvim
-- Enable: require("extras.lsp.none-ls") in init.lua.
-- Alternative formatting/diagnostics through LSP. Disable duplicated conform/nvim-lint filetypes directly in their modules.
-- Core util.format uses Conform; this module provides <leader>cN for explicit none-ls formatting instead of installing a formatter registry.
-- To make it your sole formatter, directly replace util.format's formatting call with vim.lsp.buf.format and filter client.name=='null-ls'.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load the executable-to-LSP bridge and its Lua dependency.
vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim", "https://github.com/nvimtools/none-ls.nvim" })
local nls = require("null-ls")
-- Find a project root from these markers and expose only the explicitly listed tools.
nls.setup({
  root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
  sources = {
    nls.builtins.formatting.fish_indent,
    nls.builtins.diagnostics.fish,
    nls.builtins.formatting.stylua,
    nls.builtins.formatting.shfmt,
  },
})
-- Format synchronously through null-ls only; exclude all other attached LSP clients.
vim.keymap.set({ "n", "x" }, "<leader>cN", function()
  vim.lsp.buf.format({
    async = false,
    filter = function(client)
      return client.name == "null-ls"
    end,
  })
end, { desc = "Format using none-ls" })
