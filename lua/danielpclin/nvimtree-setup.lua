
require("nvim-tree").setup({
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },    
})

vim.keymap.set("n", "<leader>vf", vim.cmd.NvimTreeToggle, { desc = '[V]iew [F]ile Tree' })

-- vim: ts=2 sts=2 sw=2 et