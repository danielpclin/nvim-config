-- perf annotations

return {
  {
    "t-troebst/perfanno.nvim",
    enabled = vim.g.vscode == nil,
    event = "VeryLazy",
    config = function()
      local perfanno = require "perfanno"
      local util = require "perfanno.util"

      -- local bgcolor = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg", "gui")
      perfanno.setup {
        -- line_highlights = util.make_bg_highlights(bgcolor, "#504ECD", 10),
        vt_highlight = util.make_fg_highlight "#504ECD",
      }
    end,
    keys = {
      -- TODO: keymap collision with <leader>p
      { "<leader>plf", ":PerfLoadFlat<CR>", noremap = true, silent = true, desc = "[P]erf [L]oad [F]lat" },
      { "<leader>plg", ":PerfLoadCallGraph<CR>", noremap = true, silent = true, desc = "[P]erf [L]oad Call [G]raph" },
      {
        "<leader>plo",
        ":PerfLoadFlameGraph<CR>",
        noremap = true,
        silent = true,
        desc = "[P]erf [L]oad [O]Flame Graph",
      },
      { "<leader>pe", ":PerfPickEvent<CR>", noremap = true, silent = true, desc = "[P]erf Pick [E]vent" },
      { "<leader>pa", ":PerfAnnotate<CR>", noremap = true, silent = true, desc = "[P]erf [A]nnotate" },
      { "<leader>pf", ":PerfAnnotateFunction<CR>", noremap = true, silent = true, desc = "[P]erf Annotate [F]unction" },
      {
        "<leader>pa",
        ":PerfAnnotateSelection<CR>",
        mode = "v",
        noremap = true,
        silent = true,
        desc = "[P]erf [A]nnotate Selection",
      },
      {
        "<leader>pt",
        ":PerfToggleAnnotations<CR>",
        noremap = true,
        silent = true,
        desc = "[P]erf [T]oggle Annotations",
      },
      { "<leader>ph", ":PerfHottestLines<CR>", noremap = true, silent = true, desc = "[P]erf [H]ottest Line" },
      { "<leader>ps", ":PerfHottestSymbols<CR>", noremap = true, silent = true, desc = "[P]erf Hottest [S]ymbols" },
      {
        "<leader>pc",
        ":PerfHottestCallersFunction<CR>",
        noremap = true,
        silent = true,
        desc = "[P]erf [H]ottest Callers Function",
      },
      {
        "<leader>pc",
        ":PerfHottestCallersSelection<CR>",
        mode = "v",
        noremap = true,
        silent = true,
        desc = "[P]erf [H]ottest Callers Selection",
      },
    },
  },
}
