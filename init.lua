vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]
require "danielpclin.options"

-- [[ Install `lazy.nvim` plugin manager ]]
require "danielpclin.lazy-bootstrap"

-- [[ Configure plugins ]]
require("lazy").setup({ import = "danielpclin/plugins" }, {
  change_detection = {
    notify = false,
  },
})

-- [[ Basic Keymaps ]]
require "danielpclin.keymaps"

-- [[ Configure Telescope ]]
-- (fuzzy finder)
require "danielpclin.telescope-setup"

-- [[ Configure Treesitter ]]
-- (syntax parser for highlighting)
require "danielpclin.treesitter-setup"

-- [[ Configure nvim-cmp ]]
-- (completion)
require "danielpclin.cmp-setup"

-- [[ Configure dap ]]
-- (debug)
require "danielpclin.dap-setup"

-- [[ Configure nvimtree ]]
-- (file tree)
require "danielpclin.nvimtree-setup"

-- [[ Configure undotree ]]
-- (undo history)
require "danielpclin.undotree-setup"

-- [[ Configure trouble ]]
-- (quickfix)
require "danielpclin.trouble-setup"

-- [[ Configure which-keys ]]
-- (pending keybinds)
require "danielpclin.whichkeys-setup"

-- [[ Configure tmux-sessionizer ]]
-- (tmux manager)
require "danielpclin.tmux-sessionizer-setup"

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
