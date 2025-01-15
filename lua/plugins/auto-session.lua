return {
  'rmagatti/auto-session',
  lazy = false,
  opts = {
    log_level = 'error',
    auto_session_enable_last_session = false,
    auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
    auto_session_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_suppress_dirs = {
      "~/",
      "~/Projects",
      "~/Downloads",
      "/",
    },
    bypass_session_save_file_types = {
      "alpha",
      "NvimTree",
      "neo-tree",
      "dashboard",
      "TelescopePrompt",
    },
    session_lens = {
      -- If load_on_setup is false, you'll need to manually load session picker
      -- by running `require("auto-session").setup_session_lens()` 
      load_on_setup = true,
      theme_conf = { border = true },
      previewer = false,
    },
    pre_save_cmds = {
      function() 
        -- Close floating windows before saving
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_config(win).relative ~= '' then
            vim.api.nvim_win_close(win, false)
          end
        end
      end,
    },
  },
  keys = {
    -- Search through sessions
    { "<leader>fss", "<cmd>SessionSave<CR>", desc = "Save session" },
    { "<leader>fsr", "<cmd>SessionRestore<CR>", desc = "Restore session" },
    { "<leader>fsd", "<cmd>SessionDelete<CR>", desc = "Delete session" },
    -- Use Telescope if installed
    { "<leader>fsf", "<cmd>SessionSearch<CR>", desc = "Find session" },
  },
  config = function(_, opts)
    local auto_session = require('auto-session')
    auto_session.setup(opts)

    -- Function to create a help window with full Vim functionality
    function _G.create_help_window()
      local buf = vim.api.nvim_create_buf(false, true)
      local width = math.floor(vim.o.columns * 0.9)
      local height = math.floor(vim.o.lines * 0.85)
      
      local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = math.floor(vim.o.lines * 0.05),
        col = math.floor(vim.o.columns * 0.05),
        style = 'minimal',
        border = 'rounded',
        title = "Help Preview",
        title_pos = "center",
      })

      -- Enable full buffer functionality
      vim.api.nvim_buf_set_option(buf, 'modifiable', true)
      vim.api.nvim_buf_set_option(buf, 'filetype', 'help')
      
      -- Add keymaps for the help window
      local opts = { buffer = buf, noremap = true, silent = true }
      vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end, opts)
      vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win, true) end, opts)
      
      -- Enable window options
      vim.api.nvim_win_set_option(win, 'wrap', true)
      vim.api.nvim_win_set_option(win, 'cursorline', true)
      vim.api.nvim_win_set_option(win, 'number', true)
      vim.api.nvim_win_set_option(win, 'relativenumber', true)

      return buf, win
    end

    -- Override the default help behavior
    vim.api.nvim_create_user_command('Help', function(opts)
      local buf, win = create_help_window()
      vim.cmd('help ' .. opts.args)
      -- Copy help content to our custom buffer
      local help_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, help_content)
    end, { nargs = 1 })
  end,
} 