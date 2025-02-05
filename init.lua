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
