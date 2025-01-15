-- Create a minimal man module for Windows
local M = {}

function M.init() end
function M.show_man_page() 
  vim.notify("Man pages are not available on Windows", vim.log.levels.INFO)
end

return M 