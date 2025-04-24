-- Git related plugins

return {
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gg", "<cmd>Git<CR>", { desc = "[G]it Fu[G]itive status" })
      vim.keymap.set("n", "<leader>gG", ":Git ", { desc = "[G]it Fu[G]itive command" })
      vim.keymap.set("n", "<leader>gs", "<cmd>Git status<CR>", { desc = "[G]it [S]tatus" })
      vim.keymap.set("n", "<leader>gaf", "<cmd>Git add %<CR>", { desc = "[G]it [A]dd Current [F]ile" })
      vim.keymap.set("n", "<leader>gaa", "<cmd>Git add .<CR>", { desc = "[G]it [A]dd [A]ll" })
      -- vim.keymap.set("n", "<leader>gaa", "<cmd>Git add %:p:h<CR>", { desc = "[G]it [A]dd [A]ll" })
      vim.keymap.set("n", "<leader>gcc", "<cmd>Git commit -a -v -q<CR>", { desc = "[G]it [C]ommit all" })
      vim.keymap.set("n", "<leader>gcC", "<cmd>Git commit -v -q<CR>", { desc = "[G]it [C]ommit" })
      vim.keymap.set("n", "<leader>gca", ":Git commit --amend", { desc = "[G]it [C]ommit [A]mend" })
      vim.keymap.set("n", "<leader>gcf", "<cmd>Git commit -v -q %:p<CR>", { desc = "[G]it [C]ommit Current [F]ile" })
      vim.keymap.set("n", "<leader>gd", "<cmd>Git diff<CR>", { desc = "[G]it [D]iff" })
      vim.keymap.set("n", "<leader>gD", ":Gdiffsplit", { desc = "[G]it [D]iff Split view" })
      vim.keymap.set("n", "<leader>ge", "<cmd>Gedit<CR>", { desc = "[G]it [E]dit index" })
      vim.keymap.set("n", "<leader>gr", "<cmd>Gread<CR>", { desc = "[G]it [R]ead index" })
      vim.keymap.set("n", "<leader>gw", "<cmd>Gwrite<CR>", { desc = "[G]it [W]rite against index" })
      vim.keymap.set("n", "<leader>gps", "<cmd>Git push<CR>", { desc = "[G]it [P]u[s]h" })
      vim.keymap.set("n", "<leader>gpl", "<cmd>Git pull<CR>", { desc = "[G]it [P]u[l]l" })
      vim.keymap.set("n", "<leader>gpf", "<cmd>Git fetch<CR>", { desc = "[G]it [P] [F]etch" })
      vim.keymap.set("n", "<leader>gm", ":Gmove ", { desc = "[G]it [M]ove index" })
      vim.keymap.set("n", "<leader>gb", ":Git branch ", { desc = "[G]it [B]ranch" })
      vim.keymap.set("n", "<leader>go", ":Git checkout ", { desc = "[G]it Check[O]ut" })
    end,
  },

  { "tpope/vim-rhubarb" },

  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
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
}
