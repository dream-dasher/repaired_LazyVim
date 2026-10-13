-- Dependencies: node; tailwindcss-language-server (npm @tailwindcss/language-server).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): none required.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Tailwind completion colors from the old nvim-cmp integration are omitted for Blink.
-- Add any additional filetypes directly to the filetypes list above.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

local filetypes = vim.tbl_filter(function(ft)
  return ft ~= "markdown"
end, vim.lsp.config.tailwindcss.filetypes or {})
vim.lsp.config("tailwindcss", {
  filetypes = filetypes,
  settings = {
    tailwindCSS = {
      includeLanguages = {
        elixir = "html-eex",
        eelixir = "html-eex",
        heex = "html-eex",
      },
    },
  },
})
vim.lsp.enable("tailwindcss")
