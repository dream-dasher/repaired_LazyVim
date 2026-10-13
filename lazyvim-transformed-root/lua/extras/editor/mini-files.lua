-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.files; Snacks for LSP file-rename notifications (default plugins/snacks.lua).
-- Docs: https://github.com/nvim-mini/mini.files
-- Enable: require("extras.editor.mini-files") in init.lua.
-- Load after plugins/snacks.lua. Uses <leader>fm/fM so it can coexist with the default Snacks explorer.
-- To replace the default explorer: set explorer.enabled=false directly in plugins/snacks.lua and use_as_default_explorer=true below.
-- File edits/renames are performed only on explicit synchronization.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/nvim-mini/mini.files" })
local files = require("mini.files")
files.setup({
  windows = { preview = true, width_focus = 30, width_preview = 30 },
  options = { use_as_default_explorer = false },
})
vim.keymap.set("n", "<leader>fm", function()
  files.open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "Files (current directory)" })
vim.keymap.set("n", "<leader>fM", function()
  files.open(vim.uv.cwd(), true)
end, { desc = "Files (cwd)" })
local hidden = true
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("config_mini_files", { clear = true }),
  pattern = "MiniFilesBufferCreate",
  callback = function(event)
    local buffer = event.data.buf_id
    vim.keymap.set("n", "g.", function()
      hidden = not hidden
      files.refresh({
        content = {
          filter = function(entry)
            return hidden or not vim.startswith(entry.name, ".")
          end,
        },
      })
    end, { buffer = buffer, desc = "Toggle hidden files" })
    vim.keymap.set("n", "gc", function()
      local entry = files.get_fs_entry()
      if entry then
        vim.fn.chdir(entry.fs_type == "directory" and entry.path or vim.fs.dirname(entry.path))
      end
    end, { buffer = buffer, desc = "Set cwd" })
    for key, direction in pairs({
      ["<C-w>s"] = "horizontal",
      ["<C-w>v"] = "vertical",
      ["<C-w>S"] = "horizontal",
      ["<C-w>V"] = "vertical",
    }) do
      vim.keymap.set("n", key, function()
        local state = files.get_explorer_state()
        if not state or not state.target_window then
          return
        end
        vim.api.nvim_win_call(state.target_window, function()
          vim.cmd("belowright " .. direction .. " split")
          files.set_target_window(vim.api.nvim_get_current_win())
        end)
        files.go_in({ close_on_file = key:match("[SV]$") ~= nil })
      end, { buffer = buffer, desc = "Open in " .. direction .. " split" })
    end
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesActionRename",
  callback = function(event)
    Snacks.rename.on_rename_file(event.data.from, event.data.to)
  end,
})
