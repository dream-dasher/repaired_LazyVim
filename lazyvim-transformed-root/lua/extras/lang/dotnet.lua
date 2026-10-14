-- Dependencies: dotnet (SDK); OmniSharp (OmniSharp release on PATH); fsautocomplete (dotnet tool); csharpier, fantomas (dotnet tools); optional netcoredbg (release).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Plugins: Hoffs/omnisharp-extended-lsp.nvim; https://github.com/Hoffs/omnisharp-extended-lsp.nvim
-- Parsers (install manually): c_sharp, fsharp.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Tools: https://github.com/OmniSharp/omnisharp-roslyn ; https://github.com/ionide/FsAutoComplete
-- Install manual dotnet tools with dotnet tool install -g fsautocomplete / csharpier / fantomas.
-- Optional tests: enable extras.test.core; add https://github.com/Nsidorenco/neotest-vstest
-- to its vim.pack.add list and require("neotest-vstest") to its adapters table.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Load definition handling for OmniSharp, including external source support.
vim.pack.add({ { src = "https://github.com/Hoffs/omnisharp-extended-lsp.nvim" } })
-- Recognize F# source, script, and signature extensions before LSP attachment.
vim.filetype.add({ extension = { fs = "fsharp", fsx = "fsharp", fsi = "fsharp" } })
-- Configure the F# server and C# analysis/import completion.
vim.lsp.config("fsautocomplete", {})
vim.lsp.config("omnisharp", {
  settings = {
    FormattingOptions = { OrganizeImports = true },
    RoslynExtensionsOptions = { EnableAnalyzersSupport = true, EnableImportCompletion = true },
  },
  -- Route definition responses through the OmniSharp extension.
  handlers = {
    ["textDocument/definition"] = function(...)
      return require("omnisharp_extended").handler(...)
    end,
  },
  -- Use the extension for definition navigation in attached C# buffers.
  on_attach = function(_, buf)
    vim.keymap.set("n", "gd", require("omnisharp_extended").lsp_definitions, { buffer = buf, desc = "Goto Definition" })
  end,
})
vim.lsp.enable({ "fsautocomplete", "omnisharp" })
-- Use language-specific external formatters for C# and F# buffers.
local conform = require("conform")
conform.formatters_by_ft.cs = { "csharpier" }
conform.formatters_by_ft.fsharp = { "fantomas" }
-- Add .NET launch configurations only when DAP is available.
local ok, dap = pcall(require, "dap")
if ok then
  dap.adapters.netcoredbg = {
    type = "executable",
    command = "netcoredbg",
    args = { "--interpreter=vscode" },
    options = { detached = false },
  }
  -- Share the debugger across .NET filetypes; select an existing DLL to run.
  for _, ft in ipairs({ "cs", "fsharp", "vb" }) do
    dap.configurations[ft] = {
      {
        type = "netcoredbg",
        name = "Launch file",
        request = "launch",
        cwd = "${workspaceFolder}",
        -- Prompt at launch time for the DLL produced by a separate build.
        program = function()
          return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
        end,
      },
    }
  end
end
