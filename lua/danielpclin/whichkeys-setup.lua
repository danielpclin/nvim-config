
-- document existing key chains
-- require('which-key').register {
--   ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
--   -- ['<leader>d'] = { name = '', _ = 'which_key_ignore' },
--   ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
--   -- ['<leader>h'] = { name = '', _ = 'which_key_ignore' },
--   ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
--   ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
--   ['<leader>v'] = { name = '[V]iew', _ = 'which_key_ignore' },
--   ['<leader>vc'] = { name = '[V]iew [C]ode', _ = 'which_key_ignore' },
--   ['<leader>vd'] = { name = '[V]iew [D]ocument', _ = 'which_key_ignore' },
--   ['<leader>vw'] = { name = '[V]iew [W]orkspace', _ = 'which_key_ignore' },
--   ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
--   ['<leader>x'] = { name = 'Troubleshoot', _ = 'which_key_ignore' },
-- }

require('which-key').add {
  { "<leader>c", group = "[C]ode" },
  { "<leader>c_", hidden = true },
  { "<leader>g", group = "[G]it" },
  { "<leader>g_", hidden = true },
  { "<leader>r", group = "[R]ename" },
  { "<leader>r_", hidden = true },
  { "<leader>s", group = "[S]earch" },
  { "<leader>s_", hidden = true },
  { "<leader>v", group = "[V]iew" },
  { "<leader>v_", hidden = true },
  { "<leader>vc", group = "[V]iew [C]ode" },
  { "<leader>vc_", hidden = true },
  { "<leader>vd", group = "[V]iew [D]ocument" },
  { "<leader>vd_", hidden = true },
  { "<leader>vw", group = "[V]iew [W]orkspace" },
  { "<leader>vw_", hidden = true },
  { "<leader>w", group = "[W]orkspace" },
  { "<leader>w_", hidden = true },
  { "<leader>x", group = "Troubleshoot" },
  { "<leader>x_", hidden = true },
}

-- vim: ts=2 sts=2 sw=2 et
