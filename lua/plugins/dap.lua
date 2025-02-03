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
        display_callback = function(variable, buf, stackframe, node, options)
          if variable.type == 'string' then
            return ' = "' .. variable.value .. '"'
          elseif variable.type == 'number' then
            return ' = ' .. variable.value
          elseif variable.type == 'bool' then
            return ' = ' .. tostring(variable.value)
          end
          return ' = ' .. variable.value
        end,
        virt_text_pos = 'eol',
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil
      })

      -- C# configuration
      dap.adapters.coreclr = {
        type = 'executable',
        command = 'netcoredbg',
        args = {'--interpreter=vscode'}
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            local cwd = vim.fn.getcwd()
            
            -- Get project name from directory
            local project_name = vim.fn.fnamemodify(cwd, ':t')
            -- Look specifically for the DLL in the expected location
            local dll_path = string.format('%s/bin/Debug/net9.0/%s.dll', cwd, project_name)
            
            if vim.fn.filereadable(dll_path) == 1 then
              vim.notify("Using DLL: " .. dll_path)
              return dll_path
            end
            
            -- If specific DLL not found, show error
            vim.notify(
              "Project DLL not found.\n" ..
              "1. Make sure you've built the project (dotnet build)\n" ..
              "2. Check if you're in the correct directory: " .. cwd .. "\n" ..
              "3. Expected DLL path: " .. dll_path,
              vim.log.levels.ERROR
            )
            return nil
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = true,
          justMyCode = false,
          console = "internalConsole",
          env = {
            ASPNETCORE_ENVIRONMENT = "Development",
            DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "false",
            LANG = "en_US.UTF-8",
            LC_ALL = "en_US.UTF-8",
          },
          replConfiguration = {
            scriptMode = true,
            initializationScript = [[
              using System;
              using System.Collections.Generic;
              using System.Linq;
              using System.Text;
              Console.OutputEncoding = System.Text.Encoding.UTF8;
            ]],
          },
          logging = {
            moduleLoad = false,
            engineLogging = true,
            programOutput = true,
          },
        },
      }

      -- Python configuration
      local function ensure_debugpy()
        local python_cmd = vim.fn.exepath('python3') or vim.fn.exepath('python')
        if not python_cmd then
          vim.notify("Python not found!", vim.log.levels.ERROR)
          return false
        end

        -- Check if debugpy is installed
        local handle = io.popen(python_cmd .. ' -c "import debugpy"')
        if handle then
          local result = handle:read("*a")
          handle:close()
          if result and result:match("ModuleNotFoundError") then
            -- Try to install debugpy
            vim.notify("Installing debugpy...", vim.log.levels.INFO)
            os.execute(python_cmd .. " -m pip install debugpy")
            
            -- Verify installation
            handle = io.popen(python_cmd .. ' -c "import debugpy"')
            if handle then
              result = handle:read("*a")
              handle:close()
              if result and result:match("ModuleNotFoundError") then
                vim.notify("Failed to install debugpy. Please install it manually with: pip install debugpy", vim.log.levels.ERROR)
                return false
              end
            end
          end
        end
        return true
      end

      if ensure_debugpy() then
        dap.adapters.python = {
          type = 'executable',
          command = vim.fn.exepath('python3') or vim.fn.exepath('python'),
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
                return vim.fn.exepath('python3') or vim.fn.exepath('python')
              end
            end,
          },
        }
      end
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

      -- Basic debugging keymaps, feel free to change to your liking!
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
              { 
                id = "repl",
                size = 0.5,
                opts = {
                  -- Enable UTF-8 encoding for REPL
                  env = {
                    PYTHONIOENCODING = "utf-8",
                    LANG = "en_US.UTF-8",
                  },
                }
              },
              {
                id = "console",
                size = 0.5,
                opts = {
                  -- Enable UTF-8 encoding for console
                  env = {
                    PYTHONIOENCODING = "utf-8",
                    LANG = "en_US.UTF-8",
                  },
                }
              },
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
        render = {
          indent = 1,
          max_value_lines = 100,
          max_type_length = 100,
          unicode = true,  -- Enable Unicode support
        },
        controls = {
          enabled = true,
          element = "repl",
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