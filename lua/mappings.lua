require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
vim.keymap.set('x', 'p', '"_dP', { noremap = true, silent = true })
vim.keymap.set('x', 'P', '"_dP', { noremap = true, silent = true })

-- Add LazyGit mapping
map("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit", silent = true })

-- Spell checking mappings
map("n", "<leader>ss", ":set spell!<CR>", { desc = "Toggle Spell Check" })
map("n", "<leader>sn", "]s", { desc = "Next misspelled word" })
map("n", "<leader>sp", "[s", { desc = "Previous misspelled word" })
map("n", "<leader>sa", "zg", { desc = "Add word to spell list" })
map("n", "<leader>s?", "z=", { desc = "Suggest corrections" })

-- FZF mappings
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fa", "<cmd>Telescope live_grep hidden=true no_ignore=true<CR>", { desc = "Grep all files" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>fr", "<cmd>Telescope frecency<CR>", { desc = "Frecency search" })

-- NvimTree at file directory
map("n", "<leader>cd", function()
  -- Get directory of current file
  local file_dir = vim.fn.expand('%:p:h')
  -- Open NvimTree at that directory
  require("nvim-tree.api").tree.open({ path = file_dir })
end, { desc = "Open tree at file dir" })
