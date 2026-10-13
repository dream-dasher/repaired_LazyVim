-- Dependencies: texlab (release); TeX distribution with latexmk; PDF viewer supporting SyncTeX (Skim/Zathura/SumatraPDF); optional pplatex.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Plugins: lervag/vimtex; https://github.com/lervag/vimtex
-- Parsers (install manually): bibtex, latex.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- VimTeX is loaded at startup so inverse search remains available.
-- Compilation is a user-invoked VimTeX action; no install/build hook runs at startup.
-- Avoid enabling a second TeX syntax highlighter; this FileType handler stops native highlighting.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.g.vimtex_mappings_disable = { n = { "K" } }
vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
vim.pack.add({ { src = "https://github.com/lervag/vimtex" } })
vim.lsp.config("texlab", {
  on_attach = function(_, buf)
    vim.keymap.set(
      "n",
      "<leader>K",
      "<plug>(vimtex-doc-package)",
      { buffer = buf, desc = "Vimtex Docs", silent = true }
    )
  end,
})
vim.lsp.enable("texlab")
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("VimtexSyntax", { clear = true }),
  pattern = { "tex", "plaintex" },
  callback = function(event)
    -- VimTeX owns syntax highlighting; keep the latex parser for other consumers.
    pcall(vim.treesitter.stop, event.buf)
  end,
})
