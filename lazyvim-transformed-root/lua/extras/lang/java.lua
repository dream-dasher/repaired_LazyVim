-- Dependencies: java >=21; python3 >=3.9 for jdtls wrapper; jdtls (Eclipse JDT LS release executable on PATH); optional prebuilt java-debug/vscode-java-test JARs.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Plugins: mfussenegger/nvim-jdtls; https://github.com/mfussenegger/nvim-jdtls
-- Parsers (install manually): java.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Java/Scala: Metals can also attach to Java; enable Java or Scala ownership for Java buffers, not both.
-- JDT LS keeps workspace indexes under stdpath("cache")/jdtls; distinct roots use distinct hashes.
-- Install optional Java bundles manually: https://github.com/mfussenegger/nvim-jdtls#debugger-via-nvim-dap
-- Lombok: add --jvm-arg=-javaagent:/absolute/path/lombok.jar to cmd if needed.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.pack.add({ { src = "https://github.com/mfussenegger/nvim-jdtls" } })
-- Single owner: jdtls.start_or_attach below; do not also vim.lsp.enable("jdtls").
local jdtls = require("jdtls")
local bundles = {} -- Put absolute paths to your manually installed debug/test JARs here.
-- Example: vim.list_extend(bundles, vim.fn.glob("/path/to/java-debug/com.microsoft.java.debug.plugin-*.jar", false, true))
-- Example: vim.list_extend(bundles, vim.fn.glob("/path/to/java-test/server/*.jar", false, true))
-- Exclude jacocoagent.jar and com.microsoft.java.test.runner-jar-with-dependencies.jar from test bundles.
local function attach(event)
  local root = vim.fs.root(
    event.buf,
    { "settings.gradle", "settings.gradle.kts", "pom.xml", "build.gradle", "build.gradle.kts", ".git" }
  ) or vim.fs.dirname(vim.api.nvim_buf_get_name(event.buf))
  if not root or root == "" then
    return
  end
  local project = vim.fs.basename(root) .. "-" .. vim.fn.sha256(root):sub(1, 12)
  local data_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project .. "/workspace"
  jdtls.start_or_attach({
    cmd = { "jdtls", "-data", data_dir },
    root_dir = root,
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    init_options = { bundles = bundles },
    settings = { java = { inlayHints = { parameterNames = { enabled = "all" } } } },
    on_attach = function(_, buf)
      for lhs, entry in pairs({
        ["<leader>cxv"] = { jdtls.extract_variable_all, "Extract Variable" },
        ["<leader>cxc"] = { jdtls.extract_constant, "Extract Constant" },
        ["<leader>cgs"] = { jdtls.super_implementation, "Goto Super" },
        ["<leader>cgS"] = { require("jdtls.tests").goto_subjects, "Goto Subjects" },
        ["<leader>co"] = { jdtls.organize_imports, "Organize Imports" },
      }) do
        vim.keymap.set("n", lhs, entry[1], { buffer = buf, desc = entry[2] })
      end
      for lhs, fn in pairs({
        ["<leader>cxm"] = "extract_method",
        ["<leader>cxv"] = "extract_variable_all",
        ["<leader>cxc"] = "extract_constant",
      }) do
        vim.keymap.set(
          "x",
          lhs,
          "<esc><cmd>lua require('jdtls')." .. fn .. "(true)<cr>",
          { buffer = buf, desc = "Java " .. fn }
        )
      end
      if #bundles > 0 and pcall(require, "dap") then
        jdtls.setup_dap({ hotcodereplace = "auto" })
        require("jdtls.dap").setup_dap_main_class_configs({})
        -- These commands require both java-debug and vscode-java-test bundles.
        vim.keymap.set("n", "<leader>tt", jdtls.test_class, { buffer = buf, desc = "Run All Tests" })
        vim.keymap.set("n", "<leader>tr", jdtls.test_nearest_method, { buffer = buf, desc = "Run Nearest Test" })
        vim.keymap.set("n", "<leader>tT", require("jdtls.dap").pick_test, { buffer = buf, desc = "Pick Test" })
      end
    end,
  })
end
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("JavaLsp", { clear = true }),
  pattern = "java",
  callback = attach,
})
local ok, dap = pcall(require, "dap")
if ok then
  dap.configurations.java =
    { { type = "java", request = "attach", name = "Debug (Attach) - Remote", hostName = "127.0.0.1", port = 5005 } }
end
