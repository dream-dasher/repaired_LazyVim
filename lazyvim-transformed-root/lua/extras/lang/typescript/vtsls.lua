-- Dependencies: node; vtsls (npm @vtsls/language-server); typescript (npm typescript).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): javascript, typescript, tsx.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Mutually exclusive with extras.lang.typescript.tsc and ts_ls.
-- Server commands: https://github.com/yioneko/vtsls
-- The command callbacks directly use this attached client; no deferred framework handlers.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Share import-update, completion, and inlay-hint settings across JS and TS.
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
-- Configure vtsls for the supported JavaScript/TypeScript buffer variants.
vim.lsp.config("vtsls", {
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  settings = {
    complete_function_calls = true,
    -- Prefer the workspace TypeScript SDK and keep completion/hints manageable.
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = { maxInlayHintLength = 30, completion = { enableServerSideFuzzyMatch = true } },
    },
    typescript = typescript,
    javascript = vim.deepcopy(typescript),
  },
  -- Install commands against the client attached to this buffer.
  on_attach = function(client, buf)
    --- Execute a vtsls command for this buffer and report server errors.
    --- When open is true, display returned LSP locations in the quickfix list.
    local function execute(command, arguments, open)
      client:exec_cmd({ command = command, arguments = arguments }, { bufnr = buf }, function(err, result)
        -- Stop on a server error before interpreting the command result.
        if err then
          vim.notify(err.message or vim.inspect(err), vim.log.levels.ERROR)
          return
        end
        -- Convert nonempty location results using this client's offset encoding.
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
    -- Navigate to implementation source or references through vtsls commands.
    vim.keymap.set("n", "gD", function()
      local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
      execute("typescript.goToSourceDefinition", { params.textDocument.uri, params.position }, true)
    end, { buffer = buf, desc = "Goto Source Definition" })
    vim.keymap.set("n", "gR", function()
      execute("typescript.findAllFileReferences", { vim.uri_from_bufnr(buf) }, true)
    end, { buffer = buf, desc = "File References" })
    -- Ask vtsls to choose the workspace TypeScript version interactively.
    vim.keymap.set("n", "<leader>cV", function()
      execute("typescript.selectTypeScriptVersion", {})
    end, { buffer = buf, desc = "Select TS Workspace Version" })
    -- Request and immediately apply only the selected import/fix-all action kind.
    for _, entry in ipairs({
      { "<leader>cM", "source.addMissingImports.ts", "Add Missing Imports" },
      { "<leader>cD", "source.fixAll.ts", "Fix All Diagnostics" },
    }) do
      vim.keymap.set("n", entry[1], function()
        vim.lsp.buf.code_action({ context = { only = { entry[2] }, diagnostics = {} }, apply = true })
      end, { buffer = buf, desc = entry[3] })
    end
    -- Handle the server's move-to-file action locally so the user can choose a path.
    client.commands["_typescript.moveToFileRefactoring"] = function(command)
      local action, uri, range = unpack(command.arguments)
      local filename = vim.uri_to_fname(uri)
      --- Send the selected destination directly to the server; nil means cancel.
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
      -- Ask tsserver for candidate files, converting LSP positions to its 1-based ranges.
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
        -- A failed or incomplete suggestion response cannot supply destinations.
        if err or not result or not result.body then
          vim.notify("TypeScript could not suggest move destinations", vim.log.levels.WARN)
          return
        end
        -- Offer existing suggestions plus an option to enter a new filename.
        local files = result.body.files or {}
        table.insert(files, 1, "Enter new path...")
        vim.ui.select(files, {
          prompt = "Select move destination:",
          -- Shorten displayed paths while retaining the full path as the choice value.
          format_item = function(f)
            return vim.fn.fnamemodify(f, ":~:.")
          end,
        }, function(path)
          -- Prompt for a new file path, or forward the selected suggestion.
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
