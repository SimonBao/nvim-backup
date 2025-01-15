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

return M