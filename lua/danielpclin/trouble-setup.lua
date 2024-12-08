vim.keymap.set("n", "<leader>xx", function()
  require("trouble").toggle()
end, { desc = "[X] Trouble" })
vim.keymap.set("n", "<leader>xw", function()
  require("trouble").toggle "workspace_diagnostics"
end, { desc = "[X] Trouble [W]orkspace Diagnostics" })
vim.keymap.set("n", "<leader>xd", function()
  require("trouble").toggle "document_diagnostics"
end, { desc = "[X] Trouble [D]ocument Diagnostics" })
vim.keymap.set("n", "<leader>xq", function()
  require("trouble").toggle "quickfix"
end, { desc = "[X] Trouble [Q]uickfix" })
vim.keymap.set("n", "<leader>xl", function()
  require("trouble").toggle "loclist"
end, { desc = "[X] Trouble [L]oclist" })
-- vim.keymap.set("n", "<leader>xt", vim.cmd.TodoTrouble, { desc = '[X] Trouble [T]odo' })
vim.keymap.set("n", "gR", function()
  require("trouble").toggle "lsp_references"
end, { desc = "[X] Trouble Lsp [R]eferences" })

-- vim: ts=2 sts=2 sw=2 et
