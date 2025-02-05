return {
  "kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  config = function()
    local surround = require("nvim-surround")
    
    surround.setup({
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "S",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
      },
    })

    -- Add custom keymaps for tag operations
    vim.keymap.set('n', 'cIt', function()
      -- Get the tag name from the command line
      local tag = vim.fn.input('Enter tag name (empty for closest): ')
      if tag and tag ~= "" then
        -- Save current position
        local save_pos = vim.fn.getcurpos()
        -- Search for the opening tag
        local found = vim.fn.search('\\V<' .. tag .. '\\v[^>]*>', 'W')
        if found > 0 then
          -- Execute the built-in cit command with insert mode
          vim.cmd('normal! citx')  -- Add 'x' to enter insert mode
          vim.cmd('normal! "_x')   -- Delete the 'x'
          vim.cmd('startinsert')   -- Ensure we're in insert mode
        else
          -- Restore position if tag not found
          vim.fn.setpos('.', save_pos)
          print("Tag <" .. tag .. "> not found")
        end
      end
    end, { desc = "Change inside first matching tag" })

    -- Add an operator-pending mapping for 'it' to fix timing issue
    vim.keymap.set('o', 'it', 'it', { remap = false })
  end,
}
