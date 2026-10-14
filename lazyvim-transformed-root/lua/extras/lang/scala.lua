-- Dependencies: java (JDK); metals (manually installed launcher, e.g. cs install metals); Scala project build tools as required.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Plugins: scalameta/nvim-metals + plenary.nvim; https://github.com/scalameta/nvim-metals
-- Parsers (install manually): scala.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Single owner: Metals initialize_or_attach; do not also enable the native metals config.
-- Java/Scala overlap is explicit: Java FileType is excluded so lang.java can own Java.
-- Metals build import/compile commands execute project builds; automatic import is off.
-- Tool setup: https://scalameta.org/metals/docs/editors/vim/
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Load Metals integration and its Lua dependency before configuring the client.
vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/scalameta/nvim-metals" },
})
-- Start from Metals defaults and add Blink completion capabilities.
local metals = require("metals")
local config = metals.bare_config()
config.capabilities = require("blink.cmp").get_lsp_capabilities()
config.init_options.statusBarProvider = "off"
-- Use the manual launcher, disable automatic build import, and show Scala hints.
config.settings = {
  useGlobalExecutable = true, -- PATH metals; no plugin-managed server install
  automaticImportBuild = "off",
  verboseCompilation = true,
  showImplicitArguments = true,
  showImplicitConversionsAndClasses = true,
  showInferredType = true,
  superMethodLensesEnabled = true,
  testUserInterface = "Test Explorer",
  excludedPackages = {
    "akka.actor.typed.javadsl",
    "org.apache.pekko.actor.typed.javadsl",
    "com.github.swagger.akka.javadsl",
  },
}
-- Add buffer-local Metals commands; initialize debugging only if DAP is present.
config.on_attach = function(_, buf)
  vim.keymap.set("n", "<leader>me", metals.commands, { buffer = buf, desc = "Metals Commands" })
  vim.keymap.set("n", "<leader>mc", metals.compile_cascade, { buffer = buf, desc = "Metals Compile Cascade" })
  vim.keymap.set("n", "<leader>mh", metals.hover_worksheet, { buffer = buf, desc = "Metals Hover Worksheet" })
  if pcall(require, "dap") then
    metals.setup_dap()
  end
end
-- On Scala/sbt filetype detection, initialize or reuse the project Metals client.
-- Java is excluded so the separate Java module can own those buffers.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ScalaLsp", { clear = true }),
  pattern = { "scala", "sbt" }, -- add "java" here only when Metals should own Java too
  callback = function()
    metals.initialize_or_attach(config)
  end,
})
-- When DAP is present, offer Metals-backed run/test launch configurations.
local ok, dap = pcall(require, "dap")
if ok then
  dap.configurations.scala = {
    { type = "scala", request = "launch", name = "RunOrTest", metals = { runType = "runOrTestFile" } },
    { type = "scala", request = "launch", name = "Test Target", metals = { runType = "testTarget" } },
  }
end
