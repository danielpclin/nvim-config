
require("nvim-tree").setup({})

vim.keymap.set("n", "<leader>vf", vim.cmd.NvimTreeToggle, { desc = '[V]iew [F]ile Tree' })

-- vim: ts=2 sts=2 sw=2 et