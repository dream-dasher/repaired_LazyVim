-- Dependencies: node; ngserver (npm @angular/language-server); project npm packages typescript + @angular/language-server for vtsls integration.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Parsers (install manually): angular, scss.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Enable extras.lang.typescript (vtsls) BEFORE this module. The native tsc alternative does not support this tsserver plugin.
-- Plugin location is project node_modules; edit location below or set NVIM_ANGULAR_TS_PLUGIN to an absolute package directory.
-- Server definition: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/angularls.lua
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

local previous_before_init = vim.lsp.config.vtsls.before_init
vim.lsp.config("vtsls", {
  before_init = function(params, config)
    if previous_before_init then
      previous_before_init(params, config)
    end
    -- Edit this location for global/custom npm layouts; default is project-local.
    local location = vim.env.NVIM_ANGULAR_TS_PLUGIN
      or vim.fs.joinpath(config.root_dir or vim.fn.getcwd(), "node_modules", "@angular/language-server")
    local settings = config.settings.vtsls
    settings.tsserver = settings.tsserver or {}
    settings.tsserver.globalPlugins = settings.tsserver.globalPlugins or {}
    table.insert(settings.tsserver.globalPlugins, {
      name = "@angular/language-server",
      location = location,
      enableForWorkspaceTypeScriptVersions = false,
    })
  end,
})
vim.lsp.config("angularls", {
  on_attach = function(client)
    client.server_capabilities.renameProvider = false
  end,
})
vim.lsp.enable("angularls")
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("AngularParser", { clear = true }),
  pattern = { "*.component.html", "*.container.html" },
  callback = function(event)
    pcall(vim.treesitter.start, event.buf, "angular")
  end,
})
-- Enable with extras.formatting.prettier if Prettier owns formatting:
-- require("conform").formatters_by_ft.htmlangular = { "prettier" }
