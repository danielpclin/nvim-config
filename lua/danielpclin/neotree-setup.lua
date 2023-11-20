
require("neo-tree").setup({
  close_if_last_window = true,
  sources = {
    "filesystem", -- Neotree filesystem source
    "buffers",
    "git_status",
    "netman.ui.neo-tree", -- The one you really care about 😉
  },
  event_handlers = {
    {
      event = "file_opened",
      handler = function(file_path)
        -- auto close
        require("neo-tree.command").execute({ action = "close" })
      end
    },
  },
  source_selector = {
    winbar = true,
    sources = {
      { source = "filesystem" },
      { source = "remote" },
      { source = "git_status" },
      -- { source = "buffers" },
    },
  },
})


vim.keymap.set("n", "<leader>vf", vim.cmd.Neotree, { desc = '[V]iew [F]ile Tree' })
vim.keymap.set("n", "<leader>vr", function() vim.cmd.Neotree 'remote' end, { desc = '[V]iew [R]emote' })
vim.keymap.set("n", "<leader>vg", function() vim.cmd.Neotree 'git_status' end, { desc = '[V]iew [G]it Status' })
vim.keymap.set("n", "<leader>vb", function() vim.cmd.Neotree 'buffers' end, { desc = '[V]iew [B]uffers' })

-- vim: ts=2 sts=2 sw=2 et