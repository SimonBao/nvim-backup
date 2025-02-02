-- Move the entire content from lua/config/dap.lua to lua/configs/dap.lua 

local dap = require("dap")

-- Debug logging with more detail
local function log_to_file(msg, level)
  local log_path = vim.fn.stdpath('cache') .. '/dap.log'
  local log_file = io.open(log_path, 'a')
  if log_file then
    local log_level = level or "INFO"
    log_file:write(string.format("[%s] %s: %s\n", 
      os.date('%Y-%m-%d %H:%M:%S'),
      log_level,
      msg))
    log_file:close()
  end
end

-- Check Python and debugpy with more detailed logging
local function check_debugpy()
  local python_cmd = vim.fn.exepath('python3') or vim.fn.exepath('python')
  if not python_cmd then
    log_to_file("No Python executable found", "ERROR")
    vim.notify("Python not found. Please install Python first.", vim.log.levels.ERROR)
    return false
  end
  log_to_file("Found Python at: " .. python_cmd)

  -- Check Python version
  local version_handle = io.popen(python_cmd .. " --version")
  if version_handle then
    local version = version_handle:read("*a")
    version_handle:close()
    log_to_file("Python version: " .. version:gsub("\n", ""))
  end

  -- Check debugpy with detailed error logging
  local check_cmd = python_cmd .. ' -c "import debugpy; print(debugpy.__file__)"'
  log_to_file("Checking debugpy with command: " .. check_cmd)
  
  local handle = io.popen(check_cmd .. " 2>&1") -- Capture stderr too
  if handle then
    local result = handle:read("*a")
    handle:close()
    
    if result:match("ModuleNotFoundError") then
      log_to_file("debugpy not found, attempting installation", "WARN")
      vim.notify("debugpy not found. Installing...", vim.log.levels.INFO)
      
      -- Try to install debugpy
      local install_cmd = python_cmd .. " -m pip install debugpy"
      log_to_file("Installing debugpy with: " .. install_cmd)
      local install_handle = io.popen(install_cmd .. " 2>&1")
      if install_handle then
        local install_result = install_handle:read("*a")
        install_handle:close()
        log_to_file("Installation result: " .. install_result)
        return check_debugpy() -- Recursive check after installation
      end
    elseif result:match("^/") or result:match("^[A-Za-z]:") then
      log_to_file("debugpy found at: " .. result:gsub("\n", ""))
      return true
    else
      log_to_file("Unexpected debugpy check result: " .. result, "ERROR")
      return false
    end
  end
  return false
end

-- Python configuration with more error handling
if check_debugpy() then
  local python_cmd = vim.fn.exepath('python3') or vim.fn.exepath('python')
  log_to_file("Configuring DAP with Python: " .. python_cmd)
  
  dap.adapters.python = {
    type = 'executable',
    command = python_cmd,
    args = { '-m', 'debugpy.adapter' },
    options = {
      env = {
        PYTHONPATH = vim.fn.getcwd(),
        PYTHONUNBUFFERED = "1",  -- Ensure Python output is not buffered
      },
    },
  }

  dap.configurations.python = {
    {
      type = 'python',
      request = 'launch',
      name = "Launch file",
      program = "${file}",
      pythonPath = function()
        local cwd = vim.fn.getcwd()
        log_to_file("Current working directory: " .. cwd)
        
        -- Check for virtual environment first
        local venv = os.getenv('VIRTUAL_ENV')
        if venv then
          local path = venv .. '/bin/python'
          if vim.fn.executable(path) == 1 then
            log_to_file("Using venv python: " .. path)
            return path
          end
        end
        
        -- Check common virtual environment paths
        for _, pattern in ipairs({ '/venv/', '/.venv/', '/env/', '/.env/' }) do
          local path = cwd .. pattern .. 'bin/python'
          if vim.fn.executable(path) == 1 then
            log_to_file("Found local venv python: " .. path)
            return path
          end
        end
        
        log_to_file("Using system python: " .. python_cmd)
        return python_cmd
      end,
      console = "integratedTerminal",
      justMyCode = false,
      stopOnEntry = false,
      showReturnValue = true,
    },
  }
else
  vim.notify("Failed to configure Python debugging. Check the DAP log for details.", vim.log.levels.ERROR)
end

-- UI configuration
vim.fn.sign_define('DapBreakpoint', { text='🛑', texthl='', linehl='', numhl='' })
vim.fn.sign_define('DapStopped', { text='▶️', texthl='', linehl='', numhl='' })

-- Add error handling to continue
local function safe_continue()
  if not dap.session() then
    vim.notify("No active debugging session!", vim.log.levels.WARN)
    return
  end
  
  local status, err = pcall(dap.continue)
  if not status then
    log_to_file("Error in dap.continue: " .. tostring(err))
    vim.notify("DAP error: " .. tostring(err), vim.log.levels.ERROR)
  end
end

-- Basic debugging keymaps with error handling
vim.keymap.set('n', '<F5>', safe_continue, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })

-- Add DAP UI integration
local has_dapui, dapui = pcall(require, "dapui")
if has_dapui then
  dapui.setup()

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
    log_to_file("DAP UI opened after initialization")
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
    log_to_file("DAP UI closed before termination")
  end
end

-- Log when DAP starts
dap.listeners.after.initialized["log"] = function()
  log_to_file("DAP initialized successfully")
end

-- Log any errors
dap.listeners.after.event_error["log"] = function(_, body)
  log_to_file("DAP error: " .. vim.inspect(body))
end 