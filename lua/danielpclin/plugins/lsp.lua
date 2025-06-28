-- LSP Configuration & Plugins

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",

      -- Ansible ft setup
      "mfussenegger/nvim-ansible",
    },
    config = function()
      require "danielpclin.lsp-setup"
    end,
  },

  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "InsertEnter",
  --   opts = {
  --   },
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

  -- Glance lsp ref/def
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    keys = {
      { "gR", "<cmd>Glance references<CR>", noremap = true, silent = true, desc = "[G]lance [R]eference" },
      { "gD", "<cmd>Glance definitions<CR>", noremap = true, silent = true, desc = "[G]lance [D]efinition" },
      { "gI", "<cmd>Glance implementations<CR>", noremap = true, silent = true, desc = "[G]lance [I]mplementation" },
    },
  },
}
