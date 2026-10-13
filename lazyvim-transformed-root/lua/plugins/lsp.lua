-- Dependencies: git for vim.pack; lua-language-server on PATH for the default Lua server.
-- Plugins: neovim/nvim-lspconfig (server definitions), Blink for completion capabilities,
-- Snacks for picker-backed navigation. Additional servers are documented by each language module.
-- No server is installed here. Docs: https://neovim.io/doc/user/lsp/
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })
local icons = require("config.icons")
local symbol_filter = {
  default = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Package",
    "Property",
    "Struct",
    "Trait",
  },
  markdown = false,
  help = false,
  lua = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Property",
    "Struct",
    "Trait",
  },
}

vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
    },
  },
})

local capabilities = require("blink.cmp").get_lsp_capabilities({
  workspace = { fileOperations = { didRename = true, willRename = true } },
})
vim.lsp.config("*", { capabilities = capabilities })
vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      codeLens = { enable = true },
      completion = { callSnippet = "Replace" },
      doc = { privateName = { "^_" } },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
    },
  },
})
vim.lsp.enable("lua_ls")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("config_lsp_attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end
    local buf = event.buf
    local function map(mode, lhs, rhs, desc, method)
      if not method or client:supports_method(method, buf) then
        vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
      end
    end
    map("n", "<leader>cl", function()
      Snacks.picker.lsp_config()
    end, "LSP Info")
    map("n", "gd", function()
      Snacks.picker.lsp_definitions()
    end, "Goto Definition", "textDocument/definition")
    map("n", "gr", function()
      Snacks.picker.lsp_references()
    end, "References", "textDocument/references")
    map("n", "gI", function()
      Snacks.picker.lsp_implementations()
    end, "Goto Implementation", "textDocument/implementation")
    map("n", "gy", function()
      Snacks.picker.lsp_type_definitions()
    end, "Goto Type Definition", "textDocument/typeDefinition")
    map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration", "textDocument/declaration")
    map("n", "K", vim.lsp.buf.hover, "Hover", "textDocument/hover")
    map("n", "gK", vim.lsp.buf.signature_help, "Signature Help", "textDocument/signatureHelp")
    map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help", "textDocument/signatureHelp")
    map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action", "textDocument/codeAction")
    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename", "textDocument/rename")
    map({ "n", "x" }, "<leader>cA", function()
      vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
    end, "Source Action", "textDocument/codeAction")
    map("n", "<leader>co", function()
      vim.lsp.buf.code_action({ apply = true, context = { only = { "source.organizeImports" }, diagnostics = {} } })
    end, "Organize Imports", "textDocument/codeAction")
    if
      client:supports_method("workspace/willRenameFiles", buf)
      or client:supports_method("workspace/didRenameFiles", buf)
    then
      map("n", "<leader>cR", function()
        Snacks.rename.rename_file()
      end, "Rename File")
    end
    map("n", "<leader>ss", function()
      Snacks.picker.lsp_symbols({ filter = symbol_filter })
    end, "LSP Symbols", "textDocument/documentSymbol")
    map("n", "<leader>sS", function()
      Snacks.picker.lsp_workspace_symbols({ filter = symbol_filter })
    end, "LSP Workspace Symbols", "workspace/symbol")
    map("n", "gai", function()
      Snacks.picker.lsp_incoming_calls()
    end, "Calls Incoming", "textDocument/prepareCallHierarchy")
    map("n", "gao", function()
      Snacks.picker.lsp_outgoing_calls()
    end, "Calls Outgoing", "textDocument/prepareCallHierarchy")
    if client:supports_method("textDocument/documentHighlight", buf) then
      map("n", "]]", function()
        Snacks.words.jump(vim.v.count1)
      end, "Next Reference")
      map("n", "[[", function()
        Snacks.words.jump(-vim.v.count1)
      end, "Previous Reference")
      map("n", "<A-n>", function()
        Snacks.words.jump(vim.v.count1, true)
      end, "Next Reference")
      map("n", "<A-p>", function()
        Snacks.words.jump(-vim.v.count1, true)
      end, "Previous Reference")
    end
    if
      vim.bo[buf].buftype == ""
      and vim.bo[buf].filetype ~= "vue"
      and client:supports_method("textDocument/inlayHint", buf)
    then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end
    if client:supports_method("textDocument/foldingRange", buf) then
      for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.wo[win][0].foldmethod = "expr"
        vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
      end
    end
    -- Automatic refresh is disabled; these maps explicitly run or refresh supported lenses.
    map({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, "Run Codelens", "textDocument/codeLens")
    map("n", "<leader>cC", function()
      vim.lsp.codelens.refresh({ bufnr = buf })
    end, "Refresh Codelens", "textDocument/codeLens")
  end,
})
