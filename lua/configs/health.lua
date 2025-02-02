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
end

return M 