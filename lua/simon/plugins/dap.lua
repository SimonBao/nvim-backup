return {
  {
    "folke/neodev.nvim",
    opts = {
      library = { plugins = { "nvim-dap-ui" }, types = true },
    }
  },
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      
      -- Enable virtual text
      vim.fn.sign_define('DapBreakpoint', { text='🛑', texthl='', linehl='', numhl='' })
      vim.fn.sign_define('DapStopped', { text='▶️', texthl='', linehl='', numhl='' })
      
      require('dap.ext.vscode').load_launchjs()
      
      -- Virtual text setup
      vim.g.dap_virtual_text = true
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = true,
        only_first_definition = true,
        all_references = true,
        clear_on_continue = false,
      })

      -- Python configuration
      dap.adapters.python = {
        type = 'executable',
        command = 'python3',
        args = { '-m', 'debugpy.adapter' },
      }
      
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = "Launch file",
          program = "${file}",
          console = "integratedTerminal",
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return '/usr/local/bin/python3'
            end
          end,
        },
      }

      -- C# Debug configuration
      dap.adapters.coreclr = {
        type = 'executable',
        command = vim.fn.expand('$HOME/.local/share/nvim-tools/netcoredbg/netcoredbg'),
        args = {'--interpreter=vscode'}
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            local cmd = "find " .. vim.fn.getcwd() .. " -name '*.dll' -type f -path '*/bin/Debug/*'"
            local handle = io.popen(cmd)
            local result = handle:read("*a")
            handle:close()
            
            local default_path = #result > 0 and result:gsub("%s+$", "") or vim.fn.getcwd() .. '/bin/Debug/'
            return vim.fn.input('Path to dll: ', default_path, 'file')
          end,
        },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "folke/neodev.nvim",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      -- Basic debugging keymaps
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end, { desc = 'Debug: Set Breakpoint' })

      -- Watch expressions
      vim.keymap.set('n', '<leader>dw', function()
        local expr = vim.fn.input('Watch Expression: ')
        if expr ~= '' then
          dapui.elements.watches.add(expr)
        end
      end, { desc = 'Debug: Add Watch Expression' })
      
      -- Add current word/selection to watches
      vim.keymap.set('n', '<leader>dW', function()
        dapui.elements.watches.add(vim.fn.expand('<cword>'))
      end, { desc = 'Debug: Add Word to Watch' })
      vim.keymap.set('v', '<leader>dW', function()
        local saved_reg = vim.fn.getreg('"')
        vim.cmd('noau normal! y')
        local selection = vim.fn.getreg('"')
        vim.fn.setreg('"', saved_reg)
        dapui.elements.watches.add(selection)
      end, { desc = 'Debug: Add Selection to Watch' })

      -- Dap UI setup
      dapui.setup({
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25,
            position = "bottom",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "single",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })

      vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
      vim.keymap.set('v', '<M-k>', dapui.eval, { desc = 'Debug: Evaluate Selection' })
      vim.keymap.set('n', '<M-k>', function() dapui.eval(vim.fn.expand('<cword>')) end, { desc = 'Debug: Quick Eval' })

      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
    end,
  }
} 