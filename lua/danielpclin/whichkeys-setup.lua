
-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  -- ['<leader>d'] = { name = '', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  -- ['<leader>h'] = { name = '', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>v'] = { name = '[V]iew', _ = 'which_key_ignore' },
  ['<leader>vc'] = { name = '[V]iew [C]ode', _ = 'which_key_ignore' },
  ['<leader>vd'] = { name = '[V]iew [D]ocument', _ = 'which_key_ignore' },
  ['<leader>vw'] = { name = '[V]iew [W]orkspace', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
  ['<leader>x'] = { name = 'Troubleshoot', _ = 'which_key_ignore' },
}

-- vim: ts=2 sts=2 sw=2 et