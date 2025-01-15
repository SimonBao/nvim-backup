return {
  {
    'akinsho/nvim-toggleterm.lua',
    lazy = false,
    config = function()
      local toggleterm = require('toggleterm')

      toggleterm.setup({
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        start_in_insert = true,
        direction = 'horizontal',
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
      })

      -- Create a Python terminal command
      local Terminal = require('toggleterm.terminal').Terminal
      local python = Terminal:new({
        cmd = "python",
        direction = "horizontal",
        hidden = true,
      })

      -- Function to run current Python file
      function _G.run_python_file()
        local file = vim.fn.expand('%:p')
        local python_term = Terminal:new({
          cmd = string.format("python %s", file),
          direction = "horizontal",
          close_on_exit = false,
        })
        python_term:toggle()
      end

      -- Add the mapping to your mappings.lua
      vim.api.nvim_create_user_command('RunPython', run_python_file, {})
    end
  }
}
