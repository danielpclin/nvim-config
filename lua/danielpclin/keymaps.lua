-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '<Up>', "v:count == 0 ? 'gk' : '<Up>'", { expr = true, silent = true })
vim.keymap.set('n', '<Down>', "v:count == 0 ? 'gj' : '<Down>'", { expr = true, silent = true })

-- Disable ex mode
vim.keymap.set("n", "Q", "<nop>")

-- Allow second paste in visual mode
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank to clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete to blackhole buffer
-- vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- Substitute all occurrences of the word under the cursor
-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

local trim_whitespace_group = vim.api.nvim_create_augroup('BufWriteTrimWhitespace', { clear = true })
vim.api.nvim_create_autocmd('BufWriteTrimWhitespace', {
  callback = function()
    MiniTrailspace.trim()
  end,
  group = trim_whitespace_group,
  pattern = '*',
})

-- vim: ts=2 sts=2 sw=2 et