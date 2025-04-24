return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {},
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        noremap = true,
        silent = true,
        desc = "[Q]Persistence Load [S]ession",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        noremap = true,
        silent = true,
        desc = "[Q]Persistence [S]elect Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load { last = true }
        end,
        noremap = true,
        silent = true,
        desc = "[Q]Persistence Load [L]ast Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        noremap = true,
        silent = true,
        desc = "[Q]Persistence Stop",
      },
    },
  },
}
