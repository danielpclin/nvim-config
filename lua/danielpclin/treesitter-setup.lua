-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
vim.defer_fn(function()
  -- Install parsers (no-op if already installed)
  require("nvim-treesitter").install({
    "c", "cpp", "go", "lua", "python", "rust",
    "tsx", "javascript", "typescript", "vimdoc", "vim", "bash",
  }, { summary = false }):wait(30000)

  -- Enable highlighting for current and future buffers
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter-highlight", { clear = true }),
    pattern = "*",
    callback = function(ev)
      pcall(vim.treesitter.start, ev.buf)
    end,
  })
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      pcall(vim.treesitter.start, buf)
    end
  end

  -- Incremental selection
  vim.keymap.set("n", "<CR>", function()
    require("nvim-treesitter.incremental_selection").init()
  end, { desc = "Init treesitter selection" })
  vim.keymap.set("x", "<CR>", function()
    require("nvim-treesitter.incremental_selection").increment()
  end, { desc = "Increment treesitter selection" })
  vim.keymap.set("x", "<BS>", function()
    require("nvim-treesitter.incremental_selection").decrement()
  end, { desc = "Decrement treesitter selection" })

  -- Textobjects
  require("nvim-treesitter-textobjects").setup({
    select = {
      lookahead = true,
      include_surrounding_whitespace = false,
    },
    move = {
      set_jumps = true,
    },
  })

  -- Select keymaps
  local select_to = require("nvim-treesitter-textobjects.select")
  local select_maps = {
    ["a="] = { "@assignment.outer", "Select outer part of an assignment" },
    ["i="] = { "@assignment.inner", "Select inner part of an assignment" },
    ["l="] = { "@assignment.lhs", "Select left hand side of an assignment" },
    ["r="] = { "@assignment.rhs", "Select right hand side of an assignment" },
    ["aa"] = { "@parameter.outer", "Select outer part of a parameter/argument" },
    ["ia"] = { "@parameter.inner", "Select inner part of a parameter/argument" },
    ["ai"] = { "@conditional.outer", "Select outer part of a conditional" },
    ["ii"] = { "@conditional.inner", "Select inner part of a conditional" },
    ["al"] = { "@loop.outer", "Select outer part of a loop" },
    ["il"] = { "@loop.inner", "Select inner part of a loop" },
    ["af"] = { "@call.outer", "Select outer part of a function call" },
    ["if"] = { "@call.inner", "Select inner part of a function call" },
    ["am"] = { "@function.outer", "Select outer part of a method/function definition" },
    ["im"] = { "@function.inner", "Select inner part of a method/function definition" },
    ["ac"] = { "@class.outer", "Select outer part of a class" },
    ["ic"] = { "@class.inner", "Select inner part of a class" },
  }
  for key, val in pairs(select_maps) do
    vim.keymap.set({ "x", "o" }, key, function()
      select_to.select_textobject(val[1], "textobjects")
    end, { desc = val[2] })
  end

  -- Move keymaps
  local move = require("nvim-treesitter-textobjects.move")
  local move_maps = {
    ["]f"] = { move.goto_next_start, "@call.outer", "Next function call start" },
    ["]m"] = { move.goto_next_start, "@function.outer", "Next method/function def start" },
    ["]c"] = { move.goto_next_start, "@class.outer", "Next class start" },
    ["]i"] = { move.goto_next_start, "@conditional.outer", "Next conditional start" },
    ["]l"] = { move.goto_next_start, "@loop.outer", "Next loop start" },
    ["]s"] = { move.goto_next_start, "@local.scope", "Next scope", "locals" },
    ["]z"] = { move.goto_next_start, "@fold", "Next fold", "folds" },
    ["]F"] = { move.goto_next_end, "@call.outer", "Next function call end" },
    ["]M"] = { move.goto_next_end, "@function.outer", "Next method/function def end" },
    ["]C"] = { move.goto_next_end, "@class.outer", "Next class end" },
    ["]I"] = { move.goto_next_end, "@conditional.outer", "Next conditional end" },
    ["]L"] = { move.goto_next_end, "@loop.outer", "Next loop end" },
    ["[f"] = { move.goto_previous_start, "@call.outer", "Prev function call start" },
    ["[m"] = { move.goto_previous_start, "@function.outer", "Prev method/function def start" },
    ["[c"] = { move.goto_previous_start, "@class.outer", "Prev class start" },
    ["[i"] = { move.goto_previous_start, "@conditional.outer", "Prev conditional start" },
    ["[l"] = { move.goto_previous_start, "@loop.outer", "Prev loop start" },
    ["[F"] = { move.goto_previous_end, "@call.outer", "Prev function call end" },
    ["[M"] = { move.goto_previous_end, "@function.outer", "Prev method/function def end" },
    ["[C"] = { move.goto_previous_end, "@class.outer", "Prev class end" },
    ["[I"] = { move.goto_previous_end, "@conditional.outer", "Prev conditional end" },
    ["[L"] = { move.goto_previous_end, "@loop.outer", "Prev loop end" },
  }
  for key, val in pairs(move_maps) do
    vim.keymap.set({ "n", "x", "o" }, key, function()
      val[1](val[2], val[4] or "textobjects")
    end, { desc = val[3] })
  end

  -- Repeatable moves with ; and ,
  local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
  vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
  vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
  vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
  vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
  vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
  vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
end, 0)

-- vim: ts=2 sts=2 sw=2 et
