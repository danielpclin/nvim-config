vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
require('danielpclin.lazy-bootstrap')

-- [[ Configure plugins ]]
require('danielpclin.lazy-plugins')

-- [[ Setting options ]]
require('danielpclin.options')

-- [[ Basic Keymaps ]]
require('danielpclin.keymaps')

-- [[ Configure Telescope ]]
-- (fuzzy finder)
require('danielpclin.telescope-setup')

-- [[ Configure Treesitter ]]
-- (syntax parser for highlighting)
require('danielpclin.treesitter-setup')

-- [[ Configure LSP ]]
-- (Language Server Protocol)
require('danielpclin.lsp-setup')

-- [[ Configure nvim-cmp ]]
-- (completion)
require('danielpclin.cmp-setup')

-- [[ Configure dap ]]
-- (debug)
require('danielpclin.dap-setup')

-- [[ Configure neotree ]]
-- (file tree)
require('danielpclin.neotree-setup')

-- [[ Configure undotree ]]
-- (undo history)
require('danielpclin.undotree-setup')

-- [[ Configure trouble ]]
-- (quickfix)
require('danielpclin.trouble-setup')

-- [[ Configure mini ]]
-- (mini)
require('danielpclin.mini-setup')

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et