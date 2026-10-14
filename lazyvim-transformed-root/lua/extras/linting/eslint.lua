-- Dependencies: node; vscode-eslint-language-server (npm vscode-langservers-extracted); eslint (project npm eslint).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): none required.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- ESLint and Oxlint/Biome may duplicate diagnostics; choose lint rules/owners deliberately.
-- Save fix ordering follows explicit module/autocmd order. Use fix_on_save=false for manual fixes.
-- Server setup: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/eslint.lua
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Enable ESLint diagnostics/actions with automatic project cwd detection and no formatting ownership.
vim.lsp.config("eslint", {
  settings = { workingDirectory = { mode = "auto" }, format = false },
})
vim.lsp.enable("eslint")
-- ESLint supplies diagnostics/actions; keep one separate formatter (Prettier/Biome/Oxfmt).
-- Save fixes are explicit and buffer-local; this ordinary autocmd replaces formatter registration.
local fix_on_save = true -- Set false if you prefer <leader>ce exclusively.
-- When an ESLint client attaches, install its buffer-local manual and optional save-fix actions.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("EslintFixes", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client or client.name ~= "eslint" then
      return
    end
    --- Apply synchronous ESLint fixes in the attached buffer, even when another buffer is current.
    local function fix()
      -- nvim-lspconfig defines the client command handler for synchronous fixes.
      vim.api.nvim_buf_call(event.buf, function()
        vim.cmd.LspEslintFixAll()
      end)
    end
    vim.keymap.set("n", "<leader>ce", fix, { buffer = event.buf, desc = "ESLint Fix All" })
    -- Replace any previous save hook for this buffer so repeated attachments do not duplicate fixes.
    vim.api.nvim_clear_autocmds({ group = "EslintFixes", event = "BufWritePre", buffer = event.buf })
    if fix_on_save then
      -- Before saving, fix this buffer only when its global/buffer autoformat setting is enabled.
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = event.buf,
        group = "EslintFixes",
        callback = function()
          if require("util.format").enabled(event.buf) then
            fix()
          end
        end,
      })
    end
  end,
})
