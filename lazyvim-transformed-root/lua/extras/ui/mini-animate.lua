-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.animate; no external executable.
-- Docs: https://github.com/nvim-mini/mini.animate
-- Enable: require("extras.ui.mini-animate") in init.lua.
-- Set scroll.enabled=false directly in plugins/snacks.lua. Disabled in Neovide (it already animates).
-- Conflicts: with smear-cursor, set cursor.enable=false below. Choose a single scroll/cursor animator.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Skip this animator inside Neovide, which already supplies its own animation.
if vim.g.neovide then
  return
end
-- Load animation timing helpers and track whether the next scroll came from the mouse wheel.
vim.pack.add({ "https://github.com/nvim-mini/mini.animate" })
local animate = require("mini.animate")
local mouse_scrolled = false
-- Mark wheel scrolling but return the same key so the native wheel action still runs.
for _, direction in ipairs({ "Up", "Down" }) do
  local key = "<ScrollWheel" .. direction .. ">"
  vim.keymap.set({ "n", "i" }, key, function()
    mouse_scrolled = true
    return key
  end, { expr = true })
end
-- Use short resize/scroll animations with evenly spaced scrolling steps.
animate.setup({
  resize = { timing = animate.gen_timing.linear({ duration = 50, unit = "total" }) },
  scroll = {
    timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
    subscroll = animate.gen_subscroll.equal({
      -- Skip animation for the next wheel scroll and for movements of at most one line.
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
-- Disable animations in search/replace buffers when their grug-far filetype is assigned.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "grug-far",
  callback = function(event)
    vim.b[event.buf].minianimate_disable = true
  end,
})
-- Toggle animations globally using the plugin's disable flag.
vim.keymap.set("n", "<leader>ua", function()
  vim.g.minianimate_disable = not vim.g.minianimate_disable
end, { desc = "Toggle animations" })
