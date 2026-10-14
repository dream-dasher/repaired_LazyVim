-- Dependencies: elixir + mix; elixir-ls (ElixirLS release wrapper on PATH); optional credo (project mix dependency).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.linting (nvim-lint).
-- Parsers (install manually): elixir, heex, eex, markdown.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Server setup: https://github.com/elixir-lsp/elixir-ls
-- Credo runs mix credo only through the conditional autocmd below; the default lint
-- autocmd does not also own it. This preserves other filetype lint configuration.
-- Optional tests: enable extras.test.core; add https://github.com/jfpedroza/neotest-elixir
-- to its vim.pack.add list and require("neotest-elixir") to its adapters table.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Reuse the Markdown parser for Livebook documents.
vim.treesitter.language.register("markdown", "livebook")
-- Configure ElixirLS and enable its language-specific refactoring commands.
vim.lsp.config("elixirls", {
  cmd = { "elixir-ls" }, -- Put a wrapper for ElixirLS language_server.sh on PATH.
  -- Add buffer-local mappings that convert between calls and pipe syntax.
  on_attach = function(client, buf)
    for _, entry in ipairs({ { "<leader>cp", "toPipe", "To Pipe" }, { "<leader>cP", "fromPipe", "From Pipe" } }) do
      vim.keymap.set("n", entry[1], function()
        -- Capture the cursor position using this client's offset encoding.
        local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
        -- ElixirLS embeds its server instance ID in this command name.
        for _, command in ipairs((client.server_capabilities.executeCommandProvider or {}).commands or {}) do
          if command:match("^manipulatePipes:") then
            client:exec_cmd({
              command = command,
              arguments = {
                entry[2],
                params.textDocument.uri,
                params.position.line,
                params.position.character,
              },
            }, { bufnr = buf })
            return
          end
        end
        -- Explain unavailable refactoring support instead of sending an unknown command.
        vim.notify("ElixirLS did not advertise manipulatePipes", vim.log.levels.WARN)
      end, { buffer = buf, desc = entry[3] })
    end
  end,
})
vim.lsp.enable("elixirls")
-- Credo is project-dependent, so only run it when the project has its config.
local lint = require("lint")
local group = vim.api.nvim_create_augroup("ElixirCredo", { clear = true })
-- On entering or saving Elixir files, run Credo only if an ancestor has
-- .credo.exs; projects without that opt-in retain their ordinary lint behavior.
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
  group = group,
  pattern = { "*.ex", "*.exs" },
  callback = function(event)
    if vim.fs.root(event.buf, ".credo.exs") then
      lint.try_lint("credo")
    end
  end,
})
