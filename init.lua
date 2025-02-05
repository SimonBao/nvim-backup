-- Set up notification handling before loading anything else
local notify_ok, notify = pcall(require, 'notify')
if notify_ok then
  vim.notify = setmetatable({
    suppress_messages = {
      "Defining diagnostic signs",
      "checkhealth",
    }
  }, {
    __call = function(self, msg, ...)
      for _, suppress in ipairs(self.suppress_messages) do
        if msg:match(suppress) then
          return
        end
      end
      return notify(msg, ...)
    end,
  })
end

-- Disable Python provider
vim.g.loaded_python3_provider = 0

-- Set Python provider with explicit path
-- Replace this path with the output from the commands above
vim.g.python3_host_prog = "C:\\Python313\\python.exe" -- Windows example
-- vim.g.python3_host_prog = '/usr/bin/python3'  -- Unix example

-- Load core configurations
require("simon.core")
require("simon.lazy")

vim.o.shada = "!,'100,<50,s10,h"
