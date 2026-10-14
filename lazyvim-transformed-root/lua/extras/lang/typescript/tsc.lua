-- Dependencies: tsc >=7.0 (native TypeScript compiler, npm typescript >=7); older TypeScript releases lack --lsp.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): javascript, typescript, tsx.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Mutually exclusive with vtsls/ts_ls; uncomment this in typescript/init.lua instead of vtsls.
-- Microsoft compiler: https://github.com/microsoft/typescript
-- Vue/Angular/Astro/Svelte plugins use tsserver/vtsls APIs and do not transfer to the native tsc server.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Configure the native compiler's LSP mode for JavaScript and TypeScript buffers.
vim.lsp.config("tsc", {
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  settings = {
    ["js/ts"] = {
      -- Show parameter/field hints while suppressing noisy inferred-type hints.
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = false },
        parameterNames = { enabled = "literals", suppressWhenArgumentMatchesName = true },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
})
vim.lsp.enable("tsc")
