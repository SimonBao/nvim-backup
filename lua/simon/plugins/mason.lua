return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua", -- Add stylua to ensure it's installed
          -- ... your other tools ...
        },
        auto_update = true,
        run_on_start = true,
      })
    end,
  },
} 