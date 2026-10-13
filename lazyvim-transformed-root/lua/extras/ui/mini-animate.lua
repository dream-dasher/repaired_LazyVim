-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.animate; no external executable.
-- Docs: https://github.com/nvim-mini/mini.animate
-- Enable: require("extras.ui.mini-animate") in init.lua.
-- Set scroll.enabled=false directly in plugins/snacks.lua. Disabled in Neovide (it already animates).
-- Conflicts: with smear-cursor, set cursor.enable=false below. Choose a single scroll/cursor animator.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

if vim.g.neovide then
  return
end
vim.pack.add({ "https://github.com/nvim-mini/mini.animate" })
local animate = require("mini.animate")
local mouse_scrolled = false
for _, direction in ipairs({ "Up", "Down" }) do
  local key = "<ScrollWheel" .. direction .. ">"
  vim.keymap.set({ "n", "i" }, key, function()
    mouse_scrolled = true
    return key
  end, { expr = true })
end
animate.setup({
  resize = { timing = animate.gen_timing.linear({ duration = 50, unit = "total" }) },
  scroll = {
    timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
    subscroll = animate.gen_subscroll.equal({
      predicate = function(total)
        if mouse_scrolled then
          mouse_scrolled = false
          return false
        end
        return total > 1
      end,
    }),
  },
  -- cursor = { enable = false }, -- when using smear-cursor
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "grug-far",
  callback = function(event)
    vim.b[event.buf].minianimate_disable = true
  end,
})
vim.keymap.set("n", "<leader>ua", function()
  vim.g.minianimate_disable = not vim.g.minianimate_disable
end, { desc = "Toggle animations" })
