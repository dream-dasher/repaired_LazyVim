-- Dependencies: Neovim >= 0.12.6; rg for :grep; a clipboard provider for unnamedplus.
-- Optional: a Nerd Font for the configured UI glyphs.
-- Docs: https://neovim.io/doc/user/options/
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Establish mapping prefixes and shared defaults before any plugin setup runs.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.autoformat = true
vim.g.snacks_animate = true
vim.g.trouble_lualine = true
-- Keep native filetype maps from shadowing configured text-object motions.
vim.g.no_plugin_maps = true

local opt = vim.opt

-- Apply general editor defaults. Snacks installs the custom status column only
-- after its setup, so plugin-installation prompts can redraw safely before then.
opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically.
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
-- Choose glyphs for folds, diff filler, and the area after the end of a buffer.
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
-- Start with open indentation folds. LSP/Tree-sitter attachment can replace
-- the fold expression later when the buffer supports those features.
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
-- Delegate operator-based formatting (such as gq) to Conform when invoked.
opt.formatexpr = "v:lua.require'conform'.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
-- Feed ripgrep's file/line/column output into Neovim's native :grep results.
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context
-- Preserve buffers, layouts, directory, and folds in sessions; keep runtimepath
-- from the current configuration rather than restoring an older saved value.
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.smoothscroll = true
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300 -- Lower than default (1000) to quickly trigger which-key
-- Keep undo history across restarts, including a longer history within each buffer.
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

-- Keep the configured indentation width instead of the Markdown runtime's defaults.
vim.g.markdown_recommended_style = 0
