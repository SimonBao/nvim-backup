return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
    },
    config = function()
      require("neodev").setup({})  -- Setup before lspconfig
      require("configs.lspconfig")
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      sync_root_with_cwd=true,
    }
  },

{
  'sudormrfbin/cheatsheet.nvim',

  requires = {
    {'nvim-telescope/telescope.nvim'},
    {'nvim-lua/popup.nvim'},
    {'nvim-lua/plenary.nvim'},
  }
  },
  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
       "html", "css",
       "python"
  		},
  	},
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "pyright",
        "html-lsp",
        "css-lsp",
        "typescript-language-server",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
    },
  },
  {
    "folke/neodev.nvim",
    lazy = false,
    priority = 100,
    config = function()
      require("neodev").setup({
        library = { 
          plugins = { "nvim-dap-ui" }, 
          types = true 
        },
      })
    end,
  },
}
