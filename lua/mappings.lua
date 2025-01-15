require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- Add the transform assignment function
local function transform_assignment()
    local line = vim.api.nvim_get_current_line()
    
    -- Get the indentation of the current line
    local indent = line:match("^%s*")
    
    -- First clean up the line - more aggressive cleaning
    local cleaned = line
        :gsub("[%(%[{]", "")         -- Remove opening brackets/braces
        :gsub("[%)%]}]", "")         -- Remove closing brackets/braces
        :gsub("=%s*", "")            -- Remove equals and its spaces
        :gsub("%s*,%s*", ",")        -- Normalize spaces around commas
        :gsub("^%s*(.-)%s*$", "%1")  -- Trim outer whitespace
    
    if cleaned then
        local assignments = {}
        -- Split by comma, ignoring whitespace issues
        for param in cleaned:gmatch("[^,]+") do
            -- Clean up the parameter name
            param = param:match("^%s*(.-)%s*$") -- Trim whitespace
            if param ~= "" then
                -- Add indentation to each line
                table.insert(assignments, indent .. param .. " = " .. param)
            end
        end
        
        if #assignments > 0 then
            -- Insert each assignment on a new line at the current position
            local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
            vim.api.nvim_buf_set_lines(0, current_line, current_line + 1, false, assignments)
        else
            vim.notify("No valid parameters found", vim.log.levels.WARN)
        end
    else
        vim.notify("No parameters found in line", vim.log.levels.WARN)
    end
end

-- Function to transform to assignments and copy to clipboard
local function transform_assignment_copy()
    local line = vim.api.nvim_get_current_line()
    
    -- Get the indentation of the current line
    local indent = line:match("^%s*")
    
    -- Clean up the line
    local cleaned = line
        :gsub("[%(%[{]", "")         -- Remove opening brackets/braces
        :gsub("[%)%]}]", "")         -- Remove closing brackets/braces
        :gsub("=%s*", "")            -- Remove equals and its spaces
        :gsub("%s*,%s*", ",")        -- Normalize spaces around commas
        :gsub("^%s*(.-)%s*$", "%1")  -- Trim outer whitespace
    
    if cleaned then
        local assignments = {}
        -- Split by comma, ignoring whitespace issues
        for param in cleaned:gmatch("[^,]+") do
            -- Clean up the parameter name
            param = param:match("^%s*(.-)%s*$") -- Trim whitespace
            if param ~= "" then
                -- Add indentation to each line
                table.insert(assignments, indent .. param .. " = " .. param)
            end
        end
        
        if #assignments > 0 then
            -- Join with newlines and copy to clipboard
            local result = table.concat(assignments, "\n")
            vim.fn.setreg('+', result)
            vim.notify("Copied assignments to clipboard", vim.log.levels.INFO)
        else
            vim.notify("No valid parameters found", vim.log.levels.WARN)
        end
    else
        vim.notify("No parameters found in line", vim.log.levels.WARN)
    end
end

map("n", "<leader>ta", transform_assignment, { desc = "Transform to assignments" })
map("n", "<leader>tc", transform_assignment_copy, { desc = "Copy assignments to clipboard" })

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

-- Add these to your existing mappings
map("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
map("n", "<leader>gd", ":Gdiffsplit<CR>", { desc = "Git diff split" })
map("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
map("n", "<leader>gl", ":Git log<CR>", { desc = "Git log" })
map("n", "<leader>gf", ":Gvdiffsplit<CR>", { desc = "Git diff vertical split" })
map("n", "<leader>tp", ":RunPython<CR>", { desc = "Run Python file" })
map("n", "<leader>tt", ":ToggleTerm<CR>", { desc = "Toggle terminal" })
