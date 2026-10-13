-- Dependencies: Neovim 0.12.6; Git for vim.pack; gh.nvim; litee.nvim; Git; GitHub CLI (`gh`) installed and authenticated manually; default icon provider.
-- Docs: https://github.com/ldelossa/gh.nvim
-- Enable: require("extras.util.gh") in init.lua.
-- Authenticate outside Neovim with `gh auth login`. Optionally enable extras.lang.git for Git syntax support.
-- Conflicts: Octo offers another GitHub workflow; choose one or distinct mappings.
-- Commands can write GitHub issues/reviews when invoked; setup performs no authentication or remote write.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/ldelossa/litee.nvim", "https://github.com/ldelossa/gh.nvim" })
require("litee.lib").setup({})
require("litee.gh").setup({})
for key, command in pairs({
  Gcc = "GHCloseCommit",
  Gce = "GHExpandCommit",
  Gco = "GHOpenToCommit",
  Gcp = "GHPopOutCommit",
  Gcz = "GHCollapseCommit",
  Gip = "GHPreviewIssue",
  Gio = "GHOpenIssue",
  Glt = "LTPanel",
  Gpc = "GHClosePR",
  Gpd = "GHPRDetails",
  Gpe = "GHExpandPR",
  Gpo = "GHOpenPR",
  Gpp = "GHPopOutPR",
  Gpr = "GHRefreshPR",
  Gpt = "GHOpenToPR",
  Gpz = "GHCollapsePR",
  Grb = "GHStartReview",
  Grc = "GHCloseReview",
  Grd = "GHDeleteReview",
  Gre = "GHExpandReview",
  Grs = "GHSubmitReview",
  Grz = "GHCollapseReview",
  Gtc = "GHCreateThread",
  Gtn = "GHNextThread",
  Gtt = "GHToggleThread",
}) do
  vim.keymap.set("n", "<leader>" .. key, "<cmd>" .. command .. "<cr>", { desc = command })
end
