require "nvchad.mappings"

local map = vim.keymap.set

-- Essential mode switches (keep these at top for fastest access)
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("i", "<Esc>", "<Esc>", { desc = "Exit insert mode" })
map("n", ":", ":", { desc = "Enter command mode" })

-- Basic operations
map("x", "p", '"_dP', { noremap = true, silent = true })
map("x", "P", '"_dP', { noremap = true, silent = true })

-- Defer loading of plugin-specific mappings
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = function()
    -- Telescope mappings
    map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
    map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
    map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
    map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })

    -- Git mappings
    map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit", silent = true })
    map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
    map("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })

    -- Terminal
    map("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })

    -- Diagnostics
    map("n", "<leader>dt", function()
      if vim.diagnostic.is_disabled() then
        vim.diagnostic.enable()
        vim.notify("Diagnostics enabled", vim.log.levels.INFO)
      else
        vim.diagnostic.disable()
        vim.notify("Diagnostics disabled", vim.log.levels.INFO)
      end
    end, { desc = "Toggle diagnostics" })
  end
})
