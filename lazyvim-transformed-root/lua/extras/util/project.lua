-- Dependencies: Neovim 0.12.6; Git for vim.pack; project.nvim; default Snacks picker; optional Git/LSP roots.
-- Docs: https://github.com/ahmedkhalf/project.nvim
-- Enable: require("extras.util.project") in init.lua.
-- Records projects only on explicit :AddProject; leaves cwd decisions to the user (manual_mode=true).
-- Load after plugins/snacks.lua/config/keymaps.lua. Conflicts: <leader>fp replaces other project pickers.
-- Dropped: dynamic picker registration, history deletion monkey patch, and injected dashboard buttons.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load explicit project recording without automatic cwd changes.
vim.pack.add({ "https://github.com/ahmedkhalf/project.nvim" })
require("project_nvim").setup({ manual_mode = true })
-- Choose a recorded project, change cwd, and open its files; cancellation leaves cwd unchanged.
vim.keymap.set("n", "<leader>fp", function()
  local history = require("project_nvim.utils.history").get_recent_projects()
  vim.ui.select(history, { prompt = "Recent project" }, function(path)
    if not path then
      return
    end
    vim.fn.chdir(path)
    Snacks.picker.files({ cwd = path })
  end)
end, { desc = "Recent projects" })
-- For Telescope instead, load its module first and uncomment:
-- require("telescope").load_extension("projects")
-- vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "Recent projects" })
