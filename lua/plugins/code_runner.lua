return {
  {
    "NvChad/nvterm",
    lazy = false,  -- Make sure it loads at startup
    config = function()
      local term = require("nvchad.term")
      
      -- Add a test print to verify config is running
      print("Code runner config loaded!")
      
      -- Function to get command based on filetype
      local function get_run_cmd()
        local file = vim.fn.expand("%:p")  -- Get full path of current file
        local ft_cmds = {
          python = "python3 " .. file,
          lua = "lua " .. file,
          javascript = "node " .. file,
          typescript = "ts-node " .. file,
          cpp = "g++ -o /tmp/out " .. file .. " && /tmp/out",
          c = "gcc -o /tmp/out " .. file .. " && /tmp/out",
          java = "javac " .. file .. " && java " .. vim.fn.expand("%:r"),
          rust = "cargo run",
          go = "go run " .. file,
          sh = "bash " .. file,
        }
        
        -- Add debug print
        print("Filetype:", vim.bo.ft)
        print("Command:", ft_cmds[vim.bo.ft])
        
        return ft_cmds[vim.bo.ft]
      end

      -- Add keymaps
      local map = vim.keymap.set
      
      -- Run code in vertical split terminal
      map("n", "<leader>rv", function()
        print("Vertical runner triggered")  -- Debug print
        local cmd = get_run_cmd()
        if cmd then
          term.runner({
            pos = "vsp",  -- vertical split
            cmd = cmd,
            id = "code_runner",
          })
        else
          vim.notify("No runner command found for filetype: " .. vim.bo.ft, vim.log.levels.WARN)
        end
      end, { desc = "Run code (vertical split)" })

      -- Run code in horizontal split terminal
      map("n", "<leader>rh", function()
        print("Horizontal runner triggered")  -- Debug print
        local cmd = get_run_cmd()
        if cmd then
          term.runner({
            pos = "sp",   -- horizontal split
            cmd = cmd,
            id = "code_runner",
          })
        else
          vim.notify("No runner command found for filetype: " .. vim.bo.ft, vim.log.levels.WARN)
        end
      end, { desc = "Run code (horizontal split)" })
    end,
  }
} 