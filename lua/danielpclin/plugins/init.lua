-- [[ Configure plugins ]]
return {
  -- Detect tabstop and shiftwidth automatically
  { "tpope/vim-sleuth" },

  -- Surroundings with ds cs ys
  { "tpope/vim-surround" },

  {
    -- TODO list
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = "onedark",
        component_separators = "|",
        section_separators = "",
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = "ibl",
    config = function()
      require("ibl").setup {
        scope = {
          enabled = false,
        },
      }
    end,
  },

  -- "gc" to comment visual regions/lines
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
      local ft = require "Comment.ft"
      ft.set("terraform-vars", { "#%s", "/*%s*/" })
    end,
  },

  {
    -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "make",
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
      "nvim-telescope/telescope-smart-history.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "kkharji/sqlite.lua",
    },
  },

  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
  },

  -- Show context
  { "nvim-treesitter/nvim-treesitter-context" },

  {
    -- Debug
    "mfussenegger/nvim-dap",
    -- NOTE: And you can specify dependencies as well
    dependencies = {
      "nvim-neotest/nvim-nio",

      -- Creates a beautiful debugger UI
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",

      -- Installs the debug adapters for you
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",

      -- Add your own debuggers here
      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",
    },
  },

  {
    -- File tree explorer
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- Undo history
  { "mbbill/undotree" },

  {
    -- Diagnostics
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },

  {
    -- Bufferline
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match "error" and " " or " "
          return " " .. icon .. count
        end,
      },
    },
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"

      npairs.setup {
        check_ts = true,
        fast_wrap = {},
      }

      npairs.add_rule(Rule("<", ">", {
        -- if you use nvim-ts-autotag, you may want to exclude these filetypes from this rule
        -- so that it doesn't conflict with nvim-ts-autotag
        "-html",
        "-javascriptreact",
        "-typescriptreact",
      }):with_pair(
        -- regex will make it so that it will auto-pair on
        -- `a<` but not `a <`
        -- The `:?:?` part makes it also
        -- work on Rust generics like `some_func::<T>()`
        cond.before_regex("%a+:?:?$", 3)
      ):with_move(function(opts)
        return opts.char == ">"
      end))
    end,
  },

  -- Hide secrets
  { "laytan/cloak.nvim", opts = {} },

  -- Better big files support (disable features on big files)
  {
    "LunarVim/bigfile.nvim",
    opts = {
      filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
      pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
      features = { -- features to disable
        "indent_blankline",
        "illuminate",
        "lsp",
        "treesitter",
        "syntax",
        "matchparen",
        "vimopts",
        "filetype",
      },
    },
  },

  -- {
  --   "catgoose/nvim-colorizer.lua",
  --   event = "BufReadPre",
  --   opts = { -- set to setup table
  --     filetypes = {
  --       "*",
  --       html = { mode = "background" },
  --     },
  --     user_default_options = {
  --       mode = "background",
  --     },
  --   },
  -- },
}

-- vim: ts=2 sts=2 sw=2 et
