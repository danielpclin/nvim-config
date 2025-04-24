-- Competitive programming helper

return {
  {
    "xeluxee/competitest.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
      require("competitest").setup {
        testcases_directory = "./testcases",
        evaluate_template_modifiers = true,
        template_file = vim.fn.stdpath "config" .. "/lua/danielpclin/templates/template.$(FEXT)",
        -- received_problems_path = function(task, file_extension)
        --   local hyphen = string.find(task.group, " - ")
        --   local judge, contest, filename
        --   if not hyphen then
        --     judge = task.group
        --     contest = "unknown_contest"
        --   else
        --     judge = string.sub(task.group, 1, hyphen - 1)
        --     contest = string.sub(task.group, hyphen + 3)
        --   end
        --   if file_extension == "java" then
        --     filename = task.languages.java.taskClass
        --   else
        --     filename = task.name
        --   end
        --   return string.format(
        --     "%s/personal/competitive-programming/%s/%s/%s.%s",
        --     vim.loop.os_homedir(),
        --     judge,
        --     contest,
        --     filename,
        --     file_extension
        --   )
        -- end,
        received_problems_path = "$(HOME)/personal/competitive-programming/$(JUDGE)/$(CONTEST)/$(PROBLEM).$(FEXT)",
        received_contests_directory = "$(HOME)/personal/competitive-programming/$(JUDGE)/$(CONTEST)",
        received_contests_problems_path = "$(PROBLEM).$(FEXT)",
        -- received_contests_problems_path = function(task, file_extension)
        --   local filename
        --   if file_extension == "java" then
        --     filename = task.languages.java.taskClass
        --   else
        --     filename = task.name
        --   end
        --   return string.format("%s.%s", filename, file_extension)
        -- end,
        popup_ui = {
          total_height = 0.9,
          total_width = 0.9,
          layout = {
            { 1, "tc" },
            { 2, { { 1, "so" }, { 1, "si" } } },
            { 2, { { 1, "eo" }, { 1, "se" } } },
          },
        },
      }
    end,
    keys = {
      { "<leader>ut", "<cmd>CompetiTest receive testcases<CR>", desc = "[U] CompetiTest Receive [T]estcases" },
      { "<leader>up", "<cmd>CompetiTest receive problem<CR>", desc = "[U] CompetiTest Receive [P]roblem" },
      { "<leader>uc", "<cmd>CompetiTest receive contest<CR>", desc = "[U] CompetiTest Receive [C]ontest" },
      { "<leader>ur", "<cmd>CompetiTest run<CR>", desc = "[U] CompetiTest [R]un" },
      { "<leader>ue", "<cmd>CompetiTest edit_testcase<CR>", desc = "[U] CompetiTest [E]dit Testcase" },
      { "<leader>ua", "<cmd>CompetiTest add_testcase<CR>", desc = "[U] CompetiTest [A]dd Testcase" },
      { "<leader>ud", "<cmd>CompetiTest delete_testcase<CR>", desc = "[U] CompetiTest [D]elete Testcase" },
    },
  },

  -- {
  --   "A7lavinraj/assistant.nvim",
  --   dependencies = { "stevearc/dressing.nvim" }, -- optional but recommended
  --   lazy = false,
  --   keys = {
  --     { "<leader>a", "<cmd>AssistantToggle<CR>", desc = "Toggle Assistant.nvim window" },
  --   },
  --   opts = {},
  -- },
}
