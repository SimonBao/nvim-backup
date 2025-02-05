return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "nvim-treesitter/nvim-treesitter",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Configure nvim-dap-virtual-text
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        virt_text_pos = vim.fn.has('nvim-0.10') == 1 and 'inline' or 'eol',
      })

      -- JavaScript/Node setup
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "\\mason\\bin\\js-debug-adapter.cmd",
          args = { "${port}" },
        }
      }
      
      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
          skipFiles = { "<node_internals>/**" },
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**" },
        },
      }
      dap.configurations.typescript = dap.configurations.javascript

      -- Python setup
      dap.adapters.python = {
        type = 'executable',
        command = 'python',
        args = { '-m', 'debugpy.adapter' },
      }
      
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            -- Detect if we're in a virtual environment
            if vim.env.VIRTUAL_ENV then
              return vim.env.VIRTUAL_ENV .. "\\Scripts\\python.exe"
            end
            -- Check for common virtual environment paths
            local cwd = vim.fn.getcwd()
            for _, pattern in ipairs({ "\\venv\\", "\\.venv\\", "\\env\\", "\\.env\\" }) do
              local path = cwd .. pattern .. "Scripts\\python.exe"
              if vim.fn.executable(path) == 1 then
                return path
              end
            end
            -- Fall back to system Python
            return vim.fn.exepath('python')
          end,
          console = "integratedTerminal",
        },
      }

      -- Basic debugging keymaps
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
      vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>B", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: Set Breakpoint" })

      -- Add virtual text for DAP
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
      vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })

      -- Define signs with both gutter icons and line highlighting
      vim.fn.sign_define('DapBreakpoint', { text='●', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointCondition', { text='ﳁ', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
      vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='DapLogPoint', numhl='DapLogPoint' })
      vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl='DapStopped' })

      -- Dap UI setup
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        controls = {
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
      })

      vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
} 