return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make"
    },
    {
      "nvim-telescope/telescope-frecency.nvim",
      dependencies = { "kkharji/sqlite.lua" },
    },
  },
  cmd = "Telescope",
  keys = {
    { "<leader>ft", "<cmd>Telescope<CR>", desc = "Open Telescope" },
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
    { "<leader>fa", "<cmd>Telescope live_grep hidden=true no_ignore=true<CR>", desc = "Grep all files" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope frecency<CR>", desc = "Frecency search" },
    { "<leader>fC", "<cmd>Telescope live_grep search_dirs=init.lua,lua,lazy-lock.json<CR>", desc = "Search config files" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local action_layout = require("telescope.actions.layout")

    telescope.setup({
      defaults = {
        vimgrep_arguments = {
          "rg",
          "-L",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
        mappings = {
          i = {
            -- Basic navigation
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-c>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            
            -- Preview scrolling
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<A-j>"] = actions.preview_scrolling_down,
            ["<A-k>"] = actions.preview_scrolling_up,
            
            -- Selection
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            
            -- Other
            ["<C-/>"] = actions.which_key,
            ["<Esc>"] = actions.close,
            ["<A-p>"] = action_layout.toggle_preview,
          },
          n = {
            -- Basic
            ["<esc>"] = actions.close,
            ["q"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            
            -- Navigation
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            
            -- Preview scrolling
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["J"] = actions.preview_scrolling_down,
            ["K"] = actions.preview_scrolling_up,
            
            -- Selection
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            
            -- Other
            ["?"] = actions.which_key,
            ["<A-p>"] = action_layout.toggle_preview,
          },
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.6,
            results_width = 0.8,
            preview_cutoff = 0,  -- Always show preview
            width = 0.9,
            height = 0.9,
          },
          vertical = {
            mirror = false,
          },
        },
        preview = {
          check_mime_type = true,  -- Enable MIME type checking
          filesize_limit = 25,     -- Don't preview files larger than 25MB
          timeout = 250,           -- Preview timeout in milliseconds
          treesitter = true,       -- Enable treesitter for better syntax highlighting
          scroll_strategy = "limit",
          hide_on_startup = false, -- Always show preview
        },
        path_display = { "truncate" },
        winblend = 0,
        border = true,
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        multi_icon = " ",
      },
      pickers = {
        find_files = {
          previewer = true,
        },
        help_tags = {
          previewer = true,
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        frecency = {
          show_scores = true,
          show_unindexed = true,
          ignore_patterns = {"*.git/*", "*/tmp/*"},
          disable_devicons = false,
          workspaces = {
            ["conf"]    = vim.fn.expand("~/.config"),
            ["data"]    = vim.fn.expand("~/.local/share"),
            ["nvim"]    = vim.fn.expand("~/.config/nvim"),
          }
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("frecency")
  end,
} 