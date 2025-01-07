return {
  {
    "nvim-telescope/telescope-frecency.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "kkharji/sqlite.lua", -- needed for frecency
    },
    config = function()
      require("telescope").load_extension("frecency")
    end,
  }
} 