-- Markdown support

return {
  -- Markdown render in browser
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
    keys = {
      { "<leader>vm", "<cmd>MarkdownPreview<CR>", noremap = true, silent = true, desc = "[V]iew [M]arkdown" },
    },
  },

  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  --   -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  --   -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  --   ---@module 'render-markdown'
  --   ---@type render.md.UserConfig
  --   opts = {
  --     code = {
  --       sign = false,
  --       width = "block",
  --       right_pad = 1,
  --     },
  --     heading = {
  --       sign = false,
  --       icons = {},
  --     },
  --     checkbox = {
  --       enabled = false,
  --     },
  --   },
  -- },

  -- {
  --   "lukas-reineke/headlines.nvim",
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   opts = {
  --     headline_highlights = {
  --       "Headline1",
  --       "Headline2",
  --       "Headline3",
  --       "Headline4",
  --       "Headline5",
  --       "Headline6",
  --     },
  --     codeblock_highlight = "CodeBlock",
  --     dash_highlight = "Dash",
  --     quote_highlight = "Quote",
  --   },
  -- },
}
