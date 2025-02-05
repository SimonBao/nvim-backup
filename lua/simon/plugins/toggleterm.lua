return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        elseif term.direction == "float" then
          return 20
        end
      end,
      hide_numbers = true,
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = 'float',
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        width = function()
          return math.floor(vim.o.columns * 0.7) -- 15% margin on each side
        end,
        height = function()
          return math.floor(vim.o.lines * 0.7)
        end,
        winblend = 3,
      },
    })

    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Terminal keymaps with consistent toggle behavior
    local Terminal = require('toggleterm.terminal').Terminal
    local float_term = Terminal:new({ direction = "float" })
    local horizontal_term = Terminal:new({ direction = "horizontal" })
    local vertical_term = Terminal:new({ direction = "vertical" })

    -- Main terminal toggle (between editor and terminal)
    keymap('n', '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = "Toggle between editor and terminal" })

    -- Terminal type toggles
    local function toggle_all_terminals()
      -- If no terminals are open, open a horizontal split terminal
      if #require("toggleterm.terminal").get_all() == 0 then
        horizontal_term:toggle()
      else
        -- Otherwise toggle all terminals
        require("toggleterm").toggle_all()
      end
    end

    -- Make Ctrl-\ work in all modes
    keymap({ 'n', 'i', 't' }, '<C-\\>', function() 
      toggle_all_terminals()
    end, { desc = "Toggle all terminals or open horizontal split" })

    keymap('n', '<F12>', function() float_term:toggle() end, { desc = "Toggle floating terminal" })
    keymap('n', '<leader>th', function() horizontal_term:toggle() end, { desc = "Toggle horizontal terminal" })
    keymap('n', '<leader>tv', function() vertical_term:toggle() end, { desc = "Toggle vertical terminal" })

    -- Terminal navigation
    function _G.set_terminal_keymaps()
      local topts = { buffer = 0 }
      keymap('t', '<esc>', [[<C-\><C-n>]], topts)
      keymap('t', 'jk', [[<C-\><C-n>]], topts)
      keymap('t', '<C-h>', [[<Cmd>wincmd h<CR>]], topts)
      keymap('t', '<C-j>', [[<Cmd>wincmd j<CR>]], topts)
      keymap('t', '<C-k>', [[<Cmd>wincmd k<CR>]], topts)
      keymap('t', '<C-l>', [[<Cmd>wincmd l<CR>]], topts)
    end

    -- Auto command to set terminal keymaps when terminal opens
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end
} 