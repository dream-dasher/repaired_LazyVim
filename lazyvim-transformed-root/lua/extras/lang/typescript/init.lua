-- Dependencies: node; vtsls (npm @vtsls/language-server); typescript (npm typescript); optional js-debug-adapter wrapper + tsx/ts-node (npm packages) for DAP.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): javascript, typescript, tsx.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- vtsls and tsc are mutually exclusive primary servers. Do not enable ts_ls alongside either.
-- Vue/Angular/Astro/Svelte TypeScript plugins below target vtsls; keep vtsls for those integrations.
-- Debug adapter: https://github.com/microsoft/vscode-js-debug (manual release install + PATH wrapper).
-- Formatting/lint ownership: enable one of Prettier/Biome/Oxc; ESLint can supply code actions separately.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- One ordinary require chooses the default. Edit this line to use the tsc module instead.
require("extras.lang.typescript.vtsls")
-- require("extras.lang.typescript.tsc") -- mutually exclusive with vtsls above
local ok, dap = pcall(require, "dap")
if ok then
  for _, kind in ipairs({ "node", "chrome", "msedge" }) do
    local pwa = "pwa-" .. kind
    dap.adapters[pwa] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = { command = "js-debug-adapter", args = { "${port}" } },
    }
    dap.adapters[kind] = function(callback, config)
      config.type = pwa
      callback(dap.adapters[pwa])
    end
  end
  local filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
  local vscode = require("dap.ext.vscode")
  vscode.type_to_filetypes.node = filetypes
  vscode.type_to_filetypes["pwa-node"] = filetypes
  for _, ft in ipairs(filetypes) do
    local runtime = ft:find("typescript") and (vim.fn.executable("tsx") == 1 and "tsx" or "ts-node") or nil
    dap.configurations[ft] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        runtimeExecutable = runtime,
        skipFiles = { "<node_internals>/**", "node_modules/**" },
        resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        runtimeExecutable = runtime,
        skipFiles = { "<node_internals>/**", "node_modules/**" },
        resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
      },
    }
  end
end
