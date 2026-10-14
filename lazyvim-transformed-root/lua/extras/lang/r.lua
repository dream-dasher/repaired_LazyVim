-- Dependencies: R; R package languageserver (manual install.packages("languageserver")).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): r, rnoweb, csv, markdown, markdown_inline, latex, yaml.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- R.nvim reference / required manual prerequisites: https://github.com/R-nvim/R.nvim
-- Default here uses the native R language server; REPL helpers remain commented because of automatic builds.
-- Optional tests: enable extras.test.core; add https://github.com/shunsambongi/neotest-testthat
-- to its vim.pack.add list and require("neotest-testthat") to its adapters table.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Configure the native R server without enabling the optional REPL plugin.
vim.lsp.config("r_language_server", {
  -- Use the nearest package/repository root, falling back to the file directory.
  root_dir = function(buf, on_dir)
    on_dir(
      vim.fs.root(buf, { "DESCRIPTION", "NAMESPACE", ".Rbuildignore", ".git" })
        or vim.fs.dirname(vim.api.nvim_buf_get_name(buf))
    )
  end,
})
vim.lsp.enable("r_language_server")

-- Optional R.nvim REPL/object browser configuration, kept as an explicit opt-in.
-- R.nvim currently builds rnvimserver/rout and installs nvimcom automatically.
-- Review these side effects before uncommenting; they write outside your config.
-- Avoid simultaneous overlapping completion/hover features from both R servers.
-- vim.pack.add({ { src = "https://github.com/R-nvim/R.nvim" } })
-- vim.g.rout_follow_colorscheme = true
-- require("r").setup({
--   R_args = { "--quiet", "--no-save" }, pdfviewer = "",
--   hook = { on_filetype = function()
--     vim.keymap.set("n", "<Enter>", "<Plug>RDSendLine", { buffer = true })
--     vim.keymap.set("x", "<Enter>", "<Plug>RSendSelection", { buffer = true })
--   end },
-- })
-- require("r.pdf.generic").open = vim.ui.open
