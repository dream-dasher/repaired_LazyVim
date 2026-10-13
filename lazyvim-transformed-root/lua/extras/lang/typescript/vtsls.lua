-- Dependencies: node; vtsls (npm @vtsls/language-server); typescript (npm typescript).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): javascript, typescript, tsx.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Mutually exclusive with extras.lang.typescript.tsc and ts_ls.
-- Server commands: https://github.com/yioneko/vtsls
-- The command callbacks directly use this attached client; no deferred framework handlers.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

local typescript = {
  updateImportsOnFileMove = { enabled = "always" },
  suggest = { completeFunctionCalls = true },
  inlayHints = {
    enumMemberValues = { enabled = true },
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = "literals" },
    parameterTypes = { enabled = true },
    propertyDeclarationTypes = { enabled = true },
    variableTypes = { enabled = false },
  },
}
vim.lsp.config("vtsls", {
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = { maxInlayHintLength = 30, completion = { enableServerSideFuzzyMatch = true } },
    },
    typescript = typescript,
    javascript = vim.deepcopy(typescript),
  },
  on_attach = function(client, buf)
    local function execute(command, arguments, open)
      client:exec_cmd({ command = command, arguments = arguments }, { bufnr = buf }, function(err, result)
        if err then
          vim.notify(err.message or vim.inspect(err), vim.log.levels.ERROR)
          return
        end
        if open and type(result) == "table" and #result > 0 then
          vim.fn.setqflist(
            {},
            " ",
            { title = command, items = vim.lsp.util.locations_to_items(result, client.offset_encoding) }
          )
          vim.cmd.copen()
        end
      end)
    end
    vim.keymap.set("n", "gD", function()
      local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
      execute("typescript.goToSourceDefinition", { params.textDocument.uri, params.position }, true)
    end, { buffer = buf, desc = "Goto Source Definition" })
    vim.keymap.set("n", "gR", function()
      execute("typescript.findAllFileReferences", { vim.uri_from_bufnr(buf) }, true)
    end, { buffer = buf, desc = "File References" })
    vim.keymap.set("n", "<leader>cV", function()
      execute("typescript.selectTypeScriptVersion", {})
    end, { buffer = buf, desc = "Select TS Workspace Version" })
    for _, entry in ipairs({
      { "<leader>cM", "source.addMissingImports.ts", "Add Missing Imports" },
      { "<leader>cD", "source.fixAll.ts", "Fix All Diagnostics" },
    }) do
      vim.keymap.set("n", entry[1], function()
        vim.lsp.buf.code_action({ context = { only = { entry[2] }, diagnostics = {} }, apply = true })
      end, { buffer = buf, desc = entry[3] })
    end
    client.commands["_typescript.moveToFileRefactoring"] = function(command)
      local action, uri, range = unpack(command.arguments)
      local filename = vim.uri_to_fname(uri)
      local function move(path)
        if path then
          -- Send to the server directly so this local client command does not recurse.
          client:request(
            "workspace/executeCommand",
            { command = command.command, arguments = { action, uri, range, path } },
            nil,
            buf
          )
        end
      end
      client:request("workspace/executeCommand", {
        command = "typescript.tsserverRequest",
        arguments = {
          "getMoveToRefactoringFileSuggestions",
          {
            file = filename,
            startLine = range.start.line + 1,
            startOffset = range.start.character + 1,
            endLine = range["end"].line + 1,
            endOffset = range["end"].character + 1,
          },
        },
      }, function(err, result)
        if err or not result or not result.body then
          vim.notify("TypeScript could not suggest move destinations", vim.log.levels.WARN)
          return
        end
        local files = result.body.files or {}
        table.insert(files, 1, "Enter new path...")
        vim.ui.select(files, {
          prompt = "Select move destination:",
          format_item = function(f)
            return vim.fn.fnamemodify(f, ":~:.")
          end,
        }, function(path)
          if path == "Enter new path..." then
            vim.ui.input(
              { prompt = "Enter move destination:", default = vim.fs.dirname(filename) .. "/", completion = "file" },
              move
            )
          elseif path then
            move(path)
          end
        end)
      end, buf)
    end
  end,
})
vim.lsp.enable("vtsls")
