return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      gitbrowse = {},
    },
    keys = {
      { "<leader>gBl", function() Snacks.gitbrowse({ what = "permalink" }) end, desc = "Git permalink", mode = { "n", "v" } },
      { "<leader>gBo", function() Snacks.gitbrowse({ what = "file" }) end, desc = "Git browse file", mode = { "n", "v" } },
      { "<leader>gBc", function() Snacks.gitbrowse({ what = "commit" }) end, desc = "Git browse commit" },
    },
  },
}
