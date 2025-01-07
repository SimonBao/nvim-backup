local M = {}

M.ui = {
  theme = "onedark",  -- or your preferred theme
  theme_toggle = { "onedark", "one_light" },
  transparency = false,
}

M.plugins = {
  options = {
    lspconfig = {
      setup_lspconf = "custom.plugins.lspconfig",
    },
  },

  user = require "custom.plugins",
}

M.mappings = require "custom.mappings"

return M 