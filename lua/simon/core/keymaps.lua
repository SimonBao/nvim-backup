vim.g.mapleader = " "

local keymap = vim.keymap

-- search
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- windows
keymap.set("n", "<leader>cw", "<cmd>close<CR>", { desc = "Close current window" })

-- undo with Ctrl+Z
keymap.set("n", "<C-z>", "u", { noremap = true, silent = true, desc = "Undo in normal mode" })
keymap.set("i", "<C-z>", "<C-o>u", { noremap = true, silent = true, desc = "Undo in insert mode" })

-- buffer navigation
keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "x", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- formatting
keymap.set("n", "<leader>tf", function()
  local conform = require("conform")
  conform.setup({ format_on_save = { timeout_ms = 500, lsp_fallback = true } })
  vim.notify("Format on save enabled", vim.log.levels.INFO)
end, { desc = "Enable format on save" })

keymap.set("n", "<leader>tF", function()
  local conform = require("conform")
  conform.setup({ format_on_save = false })
  vim.notify("Format on save disabled", vim.log.levels.INFO)
end, { desc = "Disable format on save" })
