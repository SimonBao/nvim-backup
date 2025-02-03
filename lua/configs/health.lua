local M = {}

function M.check()
  local health = vim.health or require("health")
  health.report_start("DAP Configuration Check")

  -- Check if python3 is available
  local python = vim.fn.exepath('python3') or vim.fn.exepath('python')
  if python then
    health.report_ok("Python found: " .. python)
  else
    health.report_error("Python not found")
    return
  end

  -- Check debugpy installation
  local handle = io.popen(python .. ' -c "import debugpy"')
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and result:match("ModuleNotFoundError") then
      health.report_error("debugpy not found. Install with: pip install debugpy")
    else
      health.report_ok("debugpy is installed")
    end
  end

  -- Check nvim-dap installation
  local has_dap, _ = pcall(require, "dap")
  if has_dap then
    health.report_ok("nvim-dap is installed")
  else
    health.report_error("nvim-dap is not installed")
  end

  -- Check nvim-dap-ui installation
  local has_dapui, _ = pcall(require, "dapui")
  if has_dapui then
    health.report_ok("nvim-dap-ui is installed")
  else
    health.report_warn("nvim-dap-ui is not installed (optional)")
  end

  -- Check netcoredbg installation
  local netcoredbg = vim.fn.exepath('netcoredbg')
  if netcoredbg then
    health.report_ok("netcoredbg found: " .. netcoredbg)
  else
    health.report_error("netcoredbg not found. Install with:\n" ..
      "Ubuntu/Debian: curl -L https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-linux-amd64.tar.gz -o netcoredbg.tar.gz && " ..
      "sudo tar -xvf netcoredbg.tar.gz -C /usr/local/bin/\n" ..
      "macOS: brew install netcoredbg\n" ..
      "Windows: scoop install netcoredbg")
  end

  -- Check dotnet SDK
  local handle = io.popen("dotnet --version")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and not result:match("command not found") then
      health.report_ok("dotnet SDK found: " .. result:gsub("\n", ""))
    else
      health.report_error("dotnet SDK not found. Install from https://dotnet.microsoft.com/download")
    end
  end
end

return M 