return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- load only when needed
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, -- load when buffer is read
    dependencies = {
      {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
      },
      "williamboman/mason-lspconfig.nvim",
      {
        "folke/neodev.nvim",
        opts = {
          library = { plugins = { "nvim-dap-ui" }, types = true },
        },
        lazy = true,
      },
    },
    config = function()
      require("configs.lspconfig")
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup({
        default = true,
      })
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",  -- Only load when entering insert mode
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip").setup({
        history = true,
        delete_check_events = "TextChanged",
      })
    end,
  },
}
