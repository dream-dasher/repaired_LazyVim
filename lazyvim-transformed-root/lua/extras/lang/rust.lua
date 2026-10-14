-- Dependencies: rustc + cargo; rust-analyzer (rustup component add rust-analyzer); optional codelldb (CodeLLDB release); optional bacon/bacon-ls for alternate diagnostics.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Plugins: mrcjkb/rustaceanvim, Saecki/crates.nvim, plenary.nvim; https://github.com/mrcjkb/rustaceanvim
-- Parsers (install manually): rust, ron, toml.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Crates: https://github.com/Saecki/crates.nvim ; Rust tools: https://rust-analyzer.github.io/book/installation.html
-- Cargo checks can create target/ output. Automatic cargo checks, build.rs evaluation, and proc-macro execution are disabled here.
-- For trusted projects, enable checkOnSave, cargo.buildScripts.enable, and procMacro.enable directly.
-- Run cargo check/clippy manually until then; the original automatic diagnostics are deliberately dropped.
-- Optional tests: enable extras.test.core; add https://github.com/mrcjkb/rustaceanvim
-- to its vim.pack.add list and require("rustaceanvim.neotest") to its adapters table.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Configure rust-analyzer and debugger options before the plugin scripts load.
vim.g.rustaceanvim = {
  server = {
    cmd = { "rust-analyzer" },
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    -- Add Rust-specific code-action and debuggable-target mappings on attachment.
    on_attach = function(_, buf)
      vim.keymap.set("n", "<leader>cR", "<cmd>RustLsp codeAction<cr>", { buffer = buf, desc = "Code Action" })
      vim.keymap.set("n", "<leader>dr", "<cmd>RustLsp debuggables<cr>", { buffer = buf, desc = "Rust Debuggables" })
    end,
    -- Disable automatic Cargo checks, build scripts, and proc-macro execution.
    default_settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = false } }, -- explicitly opt in if your project needs build.rs
        checkOnSave = false,
        diagnostics = { enable = true },
        procMacro = { enable = false },
        files = {
          exclude = { ".direnv", ".git", ".jj", ".github", ".gitlab", "bin", "node_modules", "target", "venv", ".venv" },
          watcher = "client",
        },
      },
    },
  },
  -- Describe the manually installed CodeLLDB adapter used for Rust debugging.
  dap = {
    adapter = {
      type = "server",
      host = "127.0.0.1",
      port = "${port}",
      executable = { command = "codelldb", args = { "--port", "${port}" } },
    },
  },
}
-- Load the Rust LSP owner and Cargo dependency tooling with its Lua dependency.
vim.pack.add({
  { src = "https://github.com/mrcjkb/rustaceanvim" },
  { src = "https://github.com/Saecki/crates.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
})
-- Enable Cargo.toml dependency completion, hover, and code actions.
require("crates").setup({
  completion = { crates = { enabled = true } },
  lsp = { enabled = true, actions = true, completion = true, hover = true },
})
-- Single owner: rustaceanvim attaches rust-analyzer; do not vim.lsp.enable("rust_analyzer").
-- Alternative diagnostics (keep rustaceanvim for navigation/completion):
-- 1. Set checkOnSave=false and diagnostics.enable=false above.
-- 2. Install bacon/bacon-ls; uncomment:
-- vim.lsp.config("bacon_ls", {})
-- vim.lsp.enable("bacon_ls")
