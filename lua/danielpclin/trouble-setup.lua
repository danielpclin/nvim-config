vim.keymap.set(
  "n",
  "<leader>xx",
  "<cmd>Trouble diagnostics toggle<cr>",
  { desc = "[x][x]Trouble", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>xX",
  "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  { desc = "[x][X]Current Buffer", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>cs",
  "<cmd>Trouble symbols toggle focus=false<cr>",
  { desc = "[C]ode [S]ymbols", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>xl",
  "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
  { desc = "[x][l]sp", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>xq",
  "<cmd>Trouble qflist toggle<cr>",
  { desc = "[x][q]uickfix", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>xL",
  "<cmd>Trouble loclist toggle<cr>",
  { desc = "[x][L]oclist", noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "[x][t]odo", noremap = true, silent = true })

-- vim: ts=2 sts=2 sw=2 et
