local plugins = {
  {
    "kdheepak/lazygit.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require "custom.plugins.lazygit"
    end,
  },
}

return plugins