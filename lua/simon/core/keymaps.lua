vim.g.mapleader = " "

local keymap = vim.keymap

-- search
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- windows
keymap.set("n", "<leader>cw", "<cmd>close<CR>", { desc = "Close current window" })

-- undo with Ctrl+Z
keymap.set("n", "<C-z>", "u", { noremap = true, silent = true, desc = "Undo in normal mode" })
keymap.set("i", "<C-z>", "<C-o>u", { noremap = true, silent = true, desc = "Undo in insert mode" })

-- tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
