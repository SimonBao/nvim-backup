local M = {}

M.ui = {
  theme = "onedark",
  theme_toggle = { "onedark", "one_light" },
  transparency = false,
}

M.plugins = {
  user = require "custom.plugins",
}

M.mappings = require "custom.mappings"

return M 