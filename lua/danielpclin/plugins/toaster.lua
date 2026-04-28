-- Toaster Dispatcher plugin for Neovim

local M = {}

local dispatchers = {
  { name = "sf-prod (avocado)", url = "http://10.50.4.87:3000" },
  { name = "sf-dev (cinnamon)", url = "http://10.50.4.90:3000" },
  { name = "tpe (formosa)", url = "http://10.16.20.222:3000" },
  { name = "tpe-setupbot", url = "http://10.16.23.72:3000" },
}

local current_dispatcher = dispatchers[1]

local function curl_json(endpoint, method, data, callback)
  local cmd = { "curl", "-s", "-L" }
  if method then
    table.insert(cmd, "-X")
    table.insert(cmd, method)
  end
  if data then
    table.insert(cmd, "-H")
    table.insert(cmd, "Content-Type: application/x-www-form-urlencoded")
    for k, v in pairs(data) do
      table.insert(cmd, "--data-urlencode")
      table.insert(cmd, k .. "=" .. tostring(v))
    end
  end
  table.insert(cmd, current_dispatcher.url .. endpoint)

  local stdout = {}
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, d) for _, l in ipairs(d) do table.insert(stdout, l) end end,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.notify("Request failed", vim.log.levels.ERROR)
        return
      end
      local ok, json = pcall(vim.json.decode, table.concat(stdout, ""))
      if ok then callback(json) else vim.notify("Failed to parse response", vim.log.levels.ERROR) end
    end,
  })
end

local function open_url(url)
  local open_cmd = vim.fn.has("mac") == 1 and "open" or "xdg-open"
  vim.fn.jobstart({ open_cmd, url }, { detach = true })
end

-- Select dispatcher
function M.select_dispatcher()
  vim.ui.select(dispatchers, {
    prompt = "Select Dispatcher:",
    format_item = function(d) return d.name end,
  }, function(choice)
    if choice then
      current_dispatcher = choice
      vim.notify("Dispatcher: " .. choice.name, vim.log.levels.INFO)
    end
  end)
end

-- List jobs
function M.list_jobs(opts)
  opts = opts or {}
  local endpoint = "/jobs?limit=" .. (opts.limit or 20)
  if opts.status then endpoint = endpoint .. "&status=" .. opts.status end

  curl_json(endpoint, nil, nil, function(json)
    if not json.data or #json.data == 0 then
      vim.notify("No jobs found", vim.log.levels.WARN)
      return
    end

    local items = {}
    for _, job in ipairs(json.data) do
      local icon = ({ queued = "", running = "", passed = "", failed = "", cancelled = "" })[job.status] or ""
      table.insert(items, {
        display = string.format("%s %s [%s] %s @ %s", icon, job.id, job.status, job.test_run, job.station_id or "unassigned"),
        job = job,
      })
    end

    vim.schedule(function()
      vim.ui.select(items, {
        prompt = "Jobs (" .. current_dispatcher.name .. "):",
        format_item = function(i) return i.display end,
      }, function(choice)
        if choice then M.job_actions(choice.job) end
      end)
    end)
  end)
end

-- Job actions menu
function M.job_actions(job)
  local actions = { " View details", " Open in browser", " Cancel job" }
  vim.ui.select(actions, { prompt = "Job #" .. job.id .. ":" }, function(action)
    if not action then return end
    if action:find("details") then
      local lines = { "Job #" .. job.id, "" }
      for k, v in pairs(job) do
        if v and v ~= "" then table.insert(lines, string.format("  %s: %s", k, tostring(v))) end
      end
      vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
    elseif action:find("browser") then
      open_url(current_dispatcher.url .. "/jobs/" .. job.id)
    elseif action:find("Cancel") then
      M.cancel_job(job.id)
    end
  end)
end

-- Cancel job
function M.cancel_job(job_id)
  curl_json("/jobs/" .. job_id, "DELETE", nil, function(json)
    vim.notify("Job #" .. job_id .. " cancelled", vim.log.levels.INFO)
  end)
end

local function station_picker(opts, on_select)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  curl_json("/stations", nil, nil, function(json)
    if not json.data then return end

    local items = {}
    for _, s in ipairs(json.data) do
      if not opts.enabled_only or not s.disabled then
        local status = s.disabled and "DISABLED" or (s.status == "available" and "AVAILABLE" or "BUSY")
        local queue_len = (s.job_queue and #s.job_queue or 0) + (s.current_job and 1 or 0)
        table.insert(items, { name = s.name, status = status, queue = queue_len, config = s.config, station = s })
      end
    end
    table.sort(items, function(a, b) return a.name < b.name end)

    vim.schedule(function()
      pickers.new({}, {
        prompt_title = opts.title or "Stations (" .. current_dispatcher.name .. ")",
        finder = finders.new_table({
          results = items,
          entry_maker = function(item)
            local display = string.format("\t%s\t%s\t%d", item.name, item.status, item.queue)
            return { value = item, display = display, ordinal = item.name }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if selection then on_select(selection.value) end
          end)
          return true
        end,
      }):find()
    end)
  end)
end

-- List stations
function M.list_stations()
  station_picker({}, function(item) M.station_actions(item.station) end)
end

-- Station actions
function M.station_actions(station)
  local toggle = station.disabled and " Enable" or " Disable"
  vim.ui.select({ " View details", toggle }, { prompt = station.name .. ":" }, function(action)
    if not action then return end
    if action:find("details") then
      local lines = { station.name, "" }
      for k, v in pairs(station) do
        if k ~= "job" and k ~= "job_queue" then
          table.insert(lines, string.format("  %s: %s", k, tostring(v)))
        end
      end
      vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
    else
      local new_status = station.disabled and "enabled" or "disabled"
      curl_json("/stations/" .. station.name, "PATCH", { status = new_status, user = "nvim" }, function()
        vim.notify(station.name .. " " .. new_status, vim.log.levels.INFO)
      end)
    end
  end)
end

local function fetch_firmwares(callback)
  local recent_cmd = { "eero", "firmware", "list", "--model", "pa" }
  local firmwares = {}

  local function run_cmd(cmd, on_done)
    local stdout = {}
    vim.fn.jobstart(cmd, {
      stdout_buffered = true,
      on_stdout = function(_, d) for _, l in ipairs(d) do if l ~= "" then table.insert(stdout, l) end end end,
      on_exit = function() on_done(stdout) end,
    })
  end

  run_cmd(recent_cmd, function(recent)
    for i = 1, math.min(30, #recent) do table.insert(firmwares, recent[i]) end
    -- Filter daniellin from the full list
    for _, fw in ipairs(recent) do
      if fw:find("daniellin") then table.insert(firmwares, fw) end
    end
    -- Remove duplicates
    local seen = {}
    local unique = {}
    for _, fw in ipairs(firmwares) do
      if not seen[fw] then
        seen[fw] = true
        table.insert(unique, fw)
      end
    end
    callback(unique)
  end)
end

-- Submit job
function M.submit_job()
  station_picker({ enabled_only = true, title = "Select Station" }, function(selected)
    fetch_firmwares(function(fw_list)
      vim.schedule(function()
        vim.ui.select(fw_list, { prompt = "Firmware:" }, function(fw)
          if not fw then return end
          vim.ui.input({ prompt = "Network group:" }, function(ng)
            if not ng then return end
            vim.ui.input({ prompt = "Test suite(s) (comma-separated, e.g. node_beta,mesh_basic):" }, function(suites)
              if not suites then return end
              vim.ui.input({ prompt = "Test rounds:", default = "1" }, function(rounds)
                if not rounds then return end
                vim.ui.input({ prompt = "Slack users:", default = "pclin" }, function(slack)
                  vim.ui.select({ "NORMAL", "URGENT", "CRITICAL" }, { prompt = "Priority:" }, function(priority)
                    if not priority then return end

                    local suite_list = vim.split(suites, ",")
                    for _, suite in ipairs(suite_list) do
                      suite = vim.trim(suite)
                      if suite ~= "" then
                        local params = {
                          test_config = selected.config,
                          test_run = suite,
                          test_firmware = fw,
                          network_group = ng,
                          test_round = rounds,
                          slack_users = slack or "",
                          priority = priority,
                        }
                        curl_json("/jobs", "POST", params, function(resp)
                          if resp.data then
                            vim.notify("Created " .. #resp.data .. " job(s) for " .. suite, vim.log.levels.INFO)
                          end
                        end)
                      end
                    end
                  end)
                end)
              end)
            end)
          end)
        end)
      end)
    end)
  end)
end

-- Health check
function M.health()
  curl_json("/health", nil, nil, function(json)
    vim.notify(current_dispatcher.name .. ": " .. (json.data and json.data.status or "unknown"), vim.log.levels.INFO)
  end)
end

return {
  dir = vim.fn.stdpath("config") .. "/lua/danielpclin/plugins",
  name = "toaster",
  lazy = true,
  cmd = { "Toaster", "ToasterJobs", "ToasterStations", "ToasterSubmit", "ToasterHealth" },
  keys = {
    { "<leader>td", function() M.select_dispatcher() end, desc = "Toaster: Select dispatcher" },
    { "<leader>tj", function() M.list_jobs() end, desc = "Toaster: List jobs" },
    { "<leader>tq", function() M.list_jobs({ status = "queued" }) end, desc = "Toaster: Queued jobs" },
    { "<leader>tr", function() M.list_jobs({ status = "running" }) end, desc = "Toaster: Running jobs" },
    { "<leader>ts", function() M.list_stations() end, desc = "Toaster: List stations" },
    { "<leader>tn", function() M.submit_job() end, desc = "Toaster: Submit new job" },
    { "<leader>th", function() M.health() end, desc = "Toaster: Health check" },
  },
  config = function()
    vim.api.nvim_create_user_command("Toaster", function() M.select_dispatcher() end, {})
    vim.api.nvim_create_user_command("ToasterJobs", function(a) M.list_jobs({ status = a.args ~= "" and a.args or nil }) end, { nargs = "?" })
    vim.api.nvim_create_user_command("ToasterStations", function() M.list_stations() end, {})
    vim.api.nvim_create_user_command("ToasterSubmit", function() M.submit_job() end, {})
    vim.api.nvim_create_user_command("ToasterHealth", function() M.health() end, {})
  end,
}
