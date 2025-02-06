return {
  "rmagatti/auto-session",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    local auto_session = require("auto-session")

    -- Function to update nvim-tree to match current directory
    local function update_tree()
      local cwd = vim.fn.getcwd()
      pcall(function()
        require("nvim-tree.api").tree.change_root(cwd)
        require("nvim-tree.api").tree.reload()
      end)
    end

    auto_session.setup({
      auto_restore_enabled = true,   -- Enable auto restore
      auto_save_enabled = false,     -- Disable auto save
      auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/" },
      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
        load_on_select = function(selected)
          local session_dir = vim.fn.fnamemodify(selected, ":p:h")
          vim.cmd("cd " .. vim.fn.fnameescape(session_dir))
        end,
      },
      pre_save_cmds = {
        function()
          -- Close nvim-tree before saving session
          require("nvim-tree.api").tree.close()
        end,
      },
      post_restore_cmds = {
        function()
          -- First update the tree root
          update_tree()
          -- Then reopen nvim-tree
          pcall(function()
            require("nvim-tree.api").tree.open()
          end)
        end,
      },
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>sd", "<cmd>SessionDelete<CR>", { desc = "Delete session for cwd" })
    keymap.set("n", "<leader>sr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
    keymap.set("n", "<leader>ss", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
    keymap.set("n", "<leader>sl", "<cmd>Telescope session-lens search_session<CR>", { desc = "List available sessions" })
  end,
}
