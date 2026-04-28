-- Jenkins build plugin for fenrir
-- Requires: JENKINS_USER and JENKINS_TOKEN environment variables

local M = {}

local jenkins_url = "https://node-build.e2ro.com"
local job_path = "/job/fenrir"

local function get_auth()
  local user = os.getenv("JENKINS_USER")
  local token = os.getenv("JENKINS_TOKEN")
  if not user or not token then
    vim.notify("JENKINS_USER and JENKINS_TOKEN env vars required", vim.log.levels.ERROR)
    return nil
  end
  return user .. ":" .. token
end

local function curl_cmd(endpoint, method, data)
  local auth = get_auth()
  if not auth then return nil end

  local cmd = { "curl", "-s", "-L", "-g", "-u", auth }
  if method then
    table.insert(cmd, "-X")
    table.insert(cmd, method)
  end
  if data then
    for k, v in pairs(data) do
      table.insert(cmd, "--data-urlencode")
      table.insert(cmd, k .. "=" .. v)
    end
  end
  table.insert(cmd, jenkins_url .. endpoint)
  return cmd
end

local function open_url(url)
  local open_cmd = vim.fn.has("mac") == 1 and "open" or "xdg-open"
  vim.fn.jobstart({ open_cmd, url }, { detach = true })
end

-- Trigger a build
function M.build(opts)
  opts = opts or {}
  local params = {
    user_environment_build = opts.user_env and "true" or "false",
    clean_up_user_environment = "false",
    notify_me_on_slack = "true",
    branch = opts.branch or "main",
    recipe_branch_override = opts.branch_override or "",
    hardware = opts.hardware or "patria",
    network_id = "",
    node_id = "",
    secureboot = "false",
    buildenv = opts.buildenv or "stage",
    relenv = opts.buildenv or "stage",
    BUILD_NAME = opts.build_name or "daniellin",
    prod_toaster_stations = "",
    dev_toaster_stations = "",
    tpe_toaster_stations = "",
    tpesetupbot_toaster_stations = "",
    jp_faro_toaster_stations = "",
    toaster_test_suites = "",
    toaster_slack_notification = "pclin",
    post_toaster_failures_to_jira = "false",
    post_toaster_result_to_testrail = "false",
    send_test_to_pytest_eero = "false",
    mesh_suite_level = "none",
    buildhistory = "false",
    should_tag = "false",
    bitbakeargs = "",
    upload_sstate = "false",
    oss = "false",
    bundle_bootloaders = "true",
    release_type = "normal_release",
  }

  local cmd = curl_cmd(job_path .. "/buildWithParameters", "POST", params)
  if not cmd then return end

  vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("Build triggered: " .. params.hardware .. " @ " .. params.branch, vim.log.levels.INFO)
      else
        vim.notify("Failed to trigger build", vim.log.levels.ERROR)
      end
    end,
  })
end

-- Get git branch for a directory
local function get_git_branch(dir)
  local cmd = "git -C " .. vim.fn.shellescape(dir) .. " rev-parse --abbrev-ref HEAD 2>/dev/null"
  local branch = vim.fn.system(cmd):gsub("%s+$", "")
  return branch ~= "" and branch or "main"
end

-- Get current project info from cwd
local function get_current_project()
  local cwd = vim.fn.getcwd()
  local name = cwd:match("([^/]+)$") or cwd
  local project = name:match("^([%w_]+)") or name
  local branch = get_git_branch(cwd)
  return { project = project, branch = branch }
end

-- Format branch override string: "project,branch;project2,branch2"
local function format_branch_override(entries)
  local parts = {}
  for _, e in ipairs(entries) do
    if e.branch ~= "main" then
      table.insert(parts, e.project .. "," .. e.branch)
    end
  end
  return table.concat(parts, ";")
end

-- Interactive build with prompts
function M.build_interactive()
  local current = get_current_project()
  -- Extract fenrir branch from branch name: daniellin/CONN-12345-v7.12.0 => v7.12.0, else main
  local fenrir_branch = current.branch:match("v[0-9]+%.[0-9]+%.[0-9]+$") or "main"
  if current.project == "fenrir" then fenrir_branch = current.branch end
  -- Build name: daniellin/CONN-12345 => daniellin-CONN-12345, daniellin/5g-test => daniellin-5g-test
  local branch_dashed = current.branch:gsub("/", "-"):gsub("%-v[0-9]+%.[0-9]+%.[0-9]+$", "")
  local default_build_name = branch_dashed:match("^[^-]+-CONN%-[0-9]+.*") or branch_dashed

  local extra_projects = {}
  if current.project ~= "goloki" then table.insert(extra_projects, "goloki") end
  if current.project ~= "nodelib" then table.insert(extra_projects, "nodelib") end

  local options = {
    "1. Current project: " .. current.project .. "," .. current.branch,
    "2. " .. current.project .. " + " .. table.concat(extra_projects, " + ") .. ": " .. current.branch,
    "3. Empty branch override",
    "4. Customize branch override",
  }

  local hw_opts = {
    "patria",
    "merci",
    "jupiter",
    "firefly",
    "andytowngateway",
    "crane",
    "patria,merci,jupiter,firefly,andytowngateway",
    "patria,merci,jupiter,firefly,andytowngateway,eden,trieste,crane,novo",
  }

  vim.ui.select(options, { prompt = "Branch override mode:" }, function(choice)
    if not choice then return end
    local mode = tonumber(choice:match("^(%d)"))

    local function do_build(branch_override)
      vim.ui.input({ prompt = "Fenrir branch: ", default = fenrir_branch }, function(branch)
        if not branch then return end
        vim.ui.select(hw_opts, { prompt = "Hardware:" }, function(hardware)
          if not hardware then return end
          vim.ui.input({ prompt = "Build name: ", default = default_build_name }, function(build_name)
            if not build_name then return end
            vim.ui.select({ "dev", "stage", "prod" }, { prompt = "Build env:" }, function(buildenv)
              if not buildenv then return end
              M.build({
                branch = branch,
                hardware = hardware,
                build_name = build_name,
                buildenv = buildenv,
                branch_override = branch_override,
              })
            end)
          end)
        end)
      end)
    end

    if mode == 1 then
      local override = format_branch_override({ current })
      do_build(override)
    elseif mode == 2 then
      local entries = { current }
      if current.project ~= "goloki" then
        table.insert(entries, { project = "goloki", branch = current.branch })
      end
      if current.project ~= "nodelib" then
        table.insert(entries, { project = "nodelib", branch = current.branch })
      end
      do_build(format_branch_override(entries))
    elseif mode == 3 then
      do_build("")
    else
      local default = format_branch_override({ current })
      vim.ui.input({ prompt = "Branch override (project,branch;...): ", default = default }, function(override)
        if not override then return end
        do_build(override)
      end)
    end
  end)
end

-- List recent builds
function M.list_builds(opts)
  opts = opts or {}
  local limit = opts.limit or 20
  local my_builds = opts.my_builds or false

  local endpoint = job_path .. "/api/json?tree=builds[number,result,timestamp,displayName,building,actions[parameters[name,value]]]"
  local cmd = curl_cmd(endpoint)
  if not cmd then return end

  local stdout_data = {}

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      for _, line in ipairs(data) do
        table.insert(stdout_data, line)
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.notify("Curl failed with code " .. code, vim.log.levels.ERROR)
        return
      end

      local json_str = table.concat(stdout_data, "")
      if json_str == "" then
        vim.notify("Empty response from Jenkins", vim.log.levels.ERROR)
        return
      end

      local ok, json = pcall(vim.json.decode, json_str)
      if not ok or not json.builds then
        vim.notify("Failed to parse builds", vim.log.levels.ERROR)
        return
      end

      local user = os.getenv("JENKINS_USER")
      local items = {}
      local count = 0

      for _, build in ipairs(json.builds) do
        if count >= limit then break end
        local name = build.displayName or ("#" .. build.number)

        if my_builds and user then
          local user_prefix = user:match("([^@]+)")
          if not name:lower():find(user_prefix:lower(), 1, true) then
            goto continue
          end
        end

        -- Nerd font icons
        local icon
        if build.building then
          icon = "" -- nf-fa-spinner
        elseif build.result == "SUCCESS" then
          icon = "" -- nf-fa-check
        elseif build.result == "FAILURE" then
          icon = "" -- nf-fa-times
        elseif build.result == "ABORTED" then
          icon = "" -- nf-fa-stop_circle
        else
          icon = "" -- nf-fa-question
        end

        -- Extract parameters from actions
        local params = {}
        if build.actions then
          for _, action in ipairs(build.actions) do
            if action.parameters then
              for _, p in ipairs(action.parameters) do
                params[p.name] = p.value
              end
              break
            end
          end
        end

        table.insert(items, {
          display = string.format("%s #%d %s", icon, build.number, name),
          number = build.number,
          url = jenkins_url .. job_path .. "/" .. build.number,
          params = params,
        })
        count = count + 1
        ::continue::
      end

      if #items == 0 then
        vim.notify("No builds found", vim.log.levels.WARN)
        return
      end

      vim.schedule(function()
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        pickers.new({}, {
          prompt_title = my_builds and "My Builds" or "Recent Builds",
          finder = finders.new_table({
            results = items,
            entry_maker = function(item)
              return { value = item, display = item.display, ordinal = item.display }
            end,
          }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              if selection then
                local choice = selection.value
                vim.ui.select({ " Open in browser", " View console", " View status", " View parameters" }, { prompt = "Action:" }, function(action)
                  if not action then return end
                  if action:find("browser") then
                    open_url(choice.url)
                  elseif action:find("console") then
                    M.console(choice.number)
                  elseif action:find("status") then
                    M.status(choice.number)
                  elseif action:find("parameters") then
                    local lines = { "Build #" .. choice.number .. " Parameters:", "" }
                    for k, v in pairs(choice.params) do
                      if v and v ~= "" then
                        table.insert(lines, string.format("  %s: %s", k, tostring(v)))
                      end
                    end
                    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
                  end
                end)
              end
            end)
            return true
          end,
        }):find()
      end)
    end,
  })
end

-- Get build status
function M.status(build_number)
  build_number = build_number or "lastBuild"
  local endpoint = job_path .. "/" .. build_number .. "/api/json?tree=number,result,building,displayName,timestamp,duration,estimatedDuration"
  local cmd = curl_cmd(endpoint)
  if not cmd then return end

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      local json_str = table.concat(data, "")
      local ok, build = pcall(vim.json.decode, json_str)
      if not ok then
        vim.notify("Failed to get build status", vim.log.levels.ERROR)
        return
      end

      local status = build.building and "BUILDING" or (build.result or "UNKNOWN")
      local duration = build.building and build.estimatedDuration or build.duration
      local mins = math.floor((duration or 0) / 60000)

      local msg = string.format(
        "Build #%d: %s\n%s\nDuration: %d min",
        build.number,
        build.displayName or "",
        status,
        mins
      )
      vim.notify(msg, vim.log.levels.INFO)
    end,
  })
end

-- View console output (last 100 lines)
function M.console(build_number)
  build_number = build_number or "lastBuild"
  local endpoint = job_path .. "/" .. build_number .. "/consoleText"
  local cmd = curl_cmd(endpoint)
  if not cmd then return end

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      local lines = {}
      for _, line in ipairs(data) do
        if line ~= "" then table.insert(lines, line) end
      end
      -- Get last 100 lines
      local start = math.max(1, #lines - 100)
      local recent = {}
      for i = start, #lines do
        table.insert(recent, lines[i])
      end

      vim.schedule(function()
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, recent)
        vim.api.nvim_buf_set_option(buf, "filetype", "log")
        vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
        vim.cmd("vsplit")
        vim.api.nvim_win_set_buf(0, buf)
        vim.api.nvim_buf_set_name(buf, "Jenkins Console #" .. build_number)
      end)
    end,
  })
end

-- Open build in browser
function M.open(build_number)
  build_number = build_number or "lastBuild"
  open_url(jenkins_url .. job_path .. "/" .. build_number)
end

-- Open job page
function M.open_job()
  open_url(jenkins_url .. job_path)
end

return {
  dir = vim.fn.stdpath("config") .. "/lua/danielpclin/plugins",
  name = "jenkins",
  lazy = true,
  cmd = { "JenkinsBuild", "JenkinsBuilds", "JenkinsMyBuilds", "JenkinsStatus", "JenkinsConsole", "JenkinsOpen" },
  keys = {
    { "<leader>jb", function() M.build_interactive() end, desc = "Jenkins: Build (interactive)" },
    { "<leader>jl", function() M.list_builds() end, desc = "Jenkins: List builds" },
    { "<leader>jm", function() M.list_builds({ my_builds = true }) end, desc = "Jenkins: My builds" },
    { "<leader>js", function() M.status() end, desc = "Jenkins: Last build status" },
    { "<leader>jc", function() M.console() end, desc = "Jenkins: Console output" },
    { "<leader>jo", function() M.open_job() end, desc = "Jenkins: Open in browser" },
  },
  config = function()
    vim.api.nvim_create_user_command("JenkinsBuild", function() M.build_interactive() end, {})
    vim.api.nvim_create_user_command("JenkinsBuilds", function() M.list_builds() end, {})
    vim.api.nvim_create_user_command("JenkinsMyBuilds", function() M.list_builds({ my_builds = true }) end, {})
    vim.api.nvim_create_user_command("JenkinsStatus", function(args) M.status(args.args ~= "" and args.args or nil) end, { nargs = "?" })
    vim.api.nvim_create_user_command("JenkinsConsole", function(args) M.console(args.args ~= "" and args.args or nil) end, { nargs = "?" })
    vim.api.nvim_create_user_command("JenkinsOpen", function(args) M.open(args.args ~= "" and args.args or nil) end, { nargs = "?" })
  end,
}
