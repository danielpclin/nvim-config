-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({

  -- Theme related
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

  -- Git related plugins
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gg", "<cmd>Git<CR>", { desc = "[G]it Fu[G]itive status" })
      vim.keymap.set("n", "<leader>ggg", ":Git ", { desc = "[G]it Fu[G]itive command" })
      vim.keymap.set("n", "<leader>gs", "<cmd>Git status<CR>", { desc = "[G]it [S]tatus" })
      vim.keymap.set("n", "<leader>gaf", "<cmd>Git add %<CR>", { desc = "[G]it [A]dd Current [F]ile" })
      vim.keymap.set("n", "<leader>gad", "<cmd>Git add %:h<CR>", { desc = "[G]it [A]dd Current [D]irectory" })
      vim.keymap.set("n", "<leader>gc", "<cmd>Git commit -v -q<CR>", { desc = "[G]it [C]ommit" })
      -- vim.keymap.set("n", "<leader>gca", ":Git commit --amend", { desc = "[G]it [C]ommit [A]mend" })
      -- vim.keymap.set("n", "<leader>gcc", "<cmd>Git commit -v -q %:p<CR>", { desc = "[G]it [C]ommit [C]urrent file" })
      vim.keymap.set("n", "<leader>gd", "<cmd>Git diff<CR>", { desc = "[G]it [D]iff" })
      -- vim.keymap.set("n", "<leader>gds", ":Gdiffsplit", { desc = "[G]it [D]iff [S]plit view" })
      vim.keymap.set("n", "<leader>ge", "<cmd>Gedit<CR>", { desc = "[G]it [E]dit index" })
      vim.keymap.set("n", "<leader>gr", "<cmd>Gread<CR>", { desc = "[G]it [R]ead index" })
      vim.keymap.set("n", "<leader>gw", "<cmd>Gwrite<CR>", { desc = "[G]it [W]rite against index" })
      vim.keymap.set("n", "<leader>gps", "<cmd>Git push<CR>", { desc = "[G]it [P]u[s]h" })
      vim.keymap.set("n", "<leader>gpl", "<cmd>Git pull<CR>", { desc = "[G]it [P]u[l]l" })
      vim.keymap.set("n", "<leader>gm", ":Gmove ", { desc = "[G]it [M]ove index" })
      vim.keymap.set("n", "<leader>gb", ":Git branch ", { desc = "[G]it [B]ranch" })
      vim.keymap.set("n", "<leader>go", ":Git checkout ", { desc = "[G]it Check[O]ut" })
    end,
  },
  { "tpope/vim-rhubarb" },

  -- Detect tabstop and shiftwidth automatically
  { "tpope/vim-sleuth" },

  -- Surroundings with ds cs ys
  { "tpope/vim-surround" },

  -- NOTE: This is where your plugins related to LSP can be installed.
  -- The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { "j-hui/fidget.nvim", opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",

      -- Ansible ft setup
      "mfussenegger/nvim-ansible",
    },
  },

  {
    -- Autocompletion
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

  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "VeryLazy",
  --   config = function(opts) require'lsp_signature'.setup(opts) end
  -- },

  {
    -- Formatting
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require "conform"

      conform.setup {
        formatters_by_ft = {
          -- javascript = { "prettier" },
          -- typescript = { "prettier" },
          -- javascriptreact = { "prettier" },
          -- typescriptreact = { "prettier" },
          -- svelte = { "prettier" },
          -- css = { "prettier" },
          -- html = { "prettier" },
          -- json = { "prettier" },
          -- yaml = { "prettier" },
          -- markdown = { "prettier" },
          -- graphql = { "prettier" },
          lua = { "stylua" },
          blade = { "blade-formatter" },
          python = { "isort", "black" },
        },
        -- Customize formatters
        formatters = {},
        -- Uncomment if you want to format on save
        -- format_on_save = {
        --   lsp_fallback = true,
        --   async = false,
        --   timeout_ms = 500,
        -- },
      }

      conform.formatters.injected = {
        options = {
          ignore_errors = false,
          lang_to_formatters = {
            sql = { "sleek" },
          },
        },
      }

      vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        conform.format {
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        }
      end, { desc = "[C]ode [F]ormat" })

      -- vim.api.nvim_create_autocmd("BufWritePre", {
      --   group = vim.api.nvim_create_augroup("custom-conform", { clear = true }),
      --   callback = function(args)
      --     require("conform").format {
      --       bufnr = args.buf,
      --       lsp_fallback = true,
      --       quiet = true,
      --     }
      --   end,
      -- })
    end,
  },

  {
    -- Linting
    "mfussenegger/nvim-lint",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      local lint = require "lint"

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        svelte = { "eslint_d" },
        python = { "pylint" },
      }

      -- local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      -- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      --   group = lint_augroup,
      --   callback = function()
      --     lint.try_lint()
      --   end,
      -- })

      vim.keymap.set("n", "<leader>cl", function()
        lint.try_lint()
      end, { desc = "[C]ode [L]int" })
    end,
  },

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim", opts = {} },

  {
    -- TODO list
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        vim.keymap.set(
          "n",
          "<leader>ghp",
          require("gitsigns").preview_hunk,
          { buffer = bufnr, desc = "[G]it [H]unk [P]review" }
        )

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ "n", "v" }, "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
        vim.keymap.set({ "n", "v" }, "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
      end,
    },
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
  { "numToStr/Comment.nvim", opts = {} },

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

  -- File explorer
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Undo history
  { "mbbill/undotree" },

  {
    -- Diagnostics
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },

  -- Mini
  { "echasnovski/mini.nvim", version = "*" },

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
    config = true,
    opts = {
      -- check_ts = true,
      fast_wrap = {},
    },
  },

  -- Hide secrets
  { "laytan/cloak.nvim", opts = {} },

  -- Competitive programming helper
  {
    "xeluxee/competitest.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
      require("competitest").setup {
        testcases_directory = "./testcases",
        evaluate_template_modifiers = true,
        template_file = vim.fn.stdpath "config" .. "/lua/danielpclin/templates/template.$(FEXT)",
        -- received_problems_path = function(task, file_extension)
        --   local hyphen = string.find(task.group, " - ")
        --   local judge, contest, filename
        --   if not hyphen then
        --     judge = task.group
        --     contest = "unknown_contest"
        --   else
        --     judge = string.sub(task.group, 1, hyphen - 1)
        --     contest = string.sub(task.group, hyphen + 3)
        --   end
        --   if file_extension == "java" then
        --     filename = task.languages.java.taskClass
        --   else
        --     filename = task.name
        --   end
        --   return string.format(
        --     "%s/personal/competitive-programming/%s/%s/%s.%s",
        --     vim.loop.os_homedir(),
        --     judge,
        --     contest,
        --     filename,
        --     file_extension
        --   )
        -- end,
        received_problems_path = "$(HOME)/personal/competitive-programming/$(JUDGE)/$(CONTEST)/$(PROBLEM).$(FEXT)",
        received_contests_directory = "$(HOME)/personal/competitive-programming/$(JUDGE)/$(CONTEST)",
        received_contests_problems_path = "$(PROBLEM).$(FEXT)",
        -- received_contests_problems_path = function(task, file_extension)
        --   local filename
        --   if file_extension == "java" then
        --     filename = task.languages.java.taskClass
        --   else
        --     filename = task.name
        --   end
        --   return string.format("%s.%s", filename, file_extension)
        -- end,
        popup_ui = {
          total_height = 0.9,
          total_width = 0.9,
          layout = {
            { 1, "tc" },
            { 2, { { 1, "so" }, { 1, "si" } } },
            { 2, { { 1, "eo" }, { 1, "se" } } },
          },
        },
      }
    end,
    keys = {
      { "<leader>ut", "<cmd>CompetiTest receive testcases<CR>", desc = "[U] CompetiTest Receive [T]estcases" },
      { "<leader>up", "<cmd>CompetiTest receive problem<CR>", desc = "[U] CompetiTest Receive [P]roblem" },
      { "<leader>uc", "<cmd>CompetiTest receive contest<CR>", desc = "[U] CompetiTest Receive [C]ontest" },
      { "<leader>ur", "<cmd>CompetiTest run<CR>", desc = "[U] CompetiTest [R]un" },
      { "<leader>ue", "<cmd>CompetiTest edit_testcase<CR>", desc = "[U] CompetiTest [E]dit Testcase" },
      { "<leader>ua", "<cmd>CompetiTest add_testcase<CR>", desc = "[U] CompetiTest [A]dd Testcase" },
      { "<leader>ud", "<cmd>CompetiTest delete_testcase<CR>", desc = "[U] CompetiTest [D]elete Testcase" },
    },
  },
  -- {
  --   "A7lavinraj/assistant.nvim",
  --   dependencies = { "stevearc/dressing.nvim" }, -- optional but recommended
  --   lazy = false,
  --   keys = {
  --     { "<leader>a", "<cmd>AssistantToggle<CR>", desc = "Toggle Assistant.nvim window" },
  --   },
  --   opts = {},
  -- },

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

  -- perf annotations
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
      { "<leader>plf", ":PerfLoadFlat<CR>", noremap = true, silent = true },
      { "<leader>plg", ":PerfLoadCallGraph<CR>", noremap = true, silent = true },
      { "<leader>plo", ":PerfLoadFlameGraph<CR>", noremap = true, silent = true },
      { "<leader>pe", ":PerfPickEvent<CR>", noremap = true, silent = true },
      { "<leader>pa", ":PerfAnnotate<CR>", noremap = true, silent = true },
      { "<leader>pf", ":PerfAnnotateFunction<CR>", noremap = true, silent = true },
      { "<leader>pa", ":PerfAnnotateSelection<CR>", noremap = true, silent = true },
      { "<leader>pt", ":PerfToggleAnnotations<CR>", noremap = true, silent = true },
      { "<leader>ph", ":PerfHottestLines<CR>", noremap = true, silent = true },
      { "<leader>ps", ":PerfHottestSymbols<CR>", noremap = true, silent = true },
      { "<leader>pc", ":PerfHottestCallersFunction<CR>", noremap = true, silent = true },
      { "<leader>pc", ":PerfHottestCallersSelection<CR>", noremap = true, silent = true },
    },
  },
}, {})

-- vim: ts=2 sts=2 sw=2 et
