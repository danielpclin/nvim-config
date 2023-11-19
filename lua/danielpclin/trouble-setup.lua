
vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end, { desc = 'TroubleToggle' })
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end, { desc = 'TroubleToggle [w]orkspace_diagnostics' })
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end, { desc = 'TroubleToggle [d]ocument_diagnostics' })
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end, { desc = 'TroubleToggle [q]uickfix' })
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end, { desc = 'TroubleToggle [l]oclist' })
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end, { desc = 'TroubleToggle lsp_[r]eferences' })

-- vim: ts=2 sts=2 sw=2 et