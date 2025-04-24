-- Autocompletion

return {
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priority = 100,
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Adds nvim lua knowledge
      "hrsh7th/cmp-nvim-lua",

      -- Adds LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",

      -- Adds calculator to completion
      "hrsh7th/cmp-calc",

      -- Adds a number of user-friendly snippets
      -- 'rafamadriz/friendly-snippets',

      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",

      -- pictograms completion-menu
      "onsails/lspkind.nvim",

      "hrsh7th/cmp-buffer",
      "roobert/tailwindcss-colorizer-cmp.nvim",
    },
  },
}
