local M = {}

M.general = {
  n = {
    -- your existing normal mode mappings
  },
  i = {
    -- your existing insert mode mappings
  },
}

M.lazygit = {
  n = {
    ["<leader>gg"] = { "<cmd>LazyGit<CR>", "Open LazyGit" },
  }
}

return M