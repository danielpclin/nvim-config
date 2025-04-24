-- Theme related

return {
  {
    -- Nightfox theme
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme 'nightfox'
    -- end,
  },

  {
    -- Theme inspired by Jetbrains
    "doums/dark.nvim",
    lazy = false,
    priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme 'dark'
    -- end,
  },

  {
    -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup {
        colors = {
          bg0 = "#192330",
        },
      }
      vim.cmd.colorscheme "onedark"
    end,
  },

  {
    -- Tokyo Night theme
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme 'tokyonight-night'
    -- end,
  },

  {
    -- Catppuccin theme
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup {
        flavor = "mocha",
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          which_key = true,
          mini = {
            enabled = true,
          },
        },
      }
      -- vim.cmd.colorscheme 'catppuccin'
    end,
  },

  {
    -- Nord theme
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme "nord"
    end,
  },

  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme "nordic"
    end,
  },
}
