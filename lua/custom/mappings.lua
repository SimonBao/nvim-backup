local M = {}

M.general = {
  n = {
    [";"] = { ";", "Repeat last f/F/t/T motion", opts = { noremap = true, silent = true } },
    [":"] = { ":", "Enter command mode", opts = { noremap = true } },
  }
}

M.lazygit = {
  n = {
    ["<leader>gg"] = { "<cmd>LazyGit<CR>", "Open LazyGit" },
  }
}

M.telescope = {
  n = {
    ["<leader>fc"] = {
      function()
        require("telescope.builtin").live_grep({
          prompt_title = "Search Config Files",
          search_dirs = {
            "init.lua",
            "lua",
            "lazy-lock.json"
          },
        })
      end,
      "Search config files"
    },
  }
}

return M