return {
  "rmagatti/auto-session",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = false,  -- Disable auto restore temporarily
      auto_save_enabled = true,      -- Keep auto save enabled
      auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/" },
      session_lens = {
        -- If you don't want the session-lens (telescope plugin for sessions), remove this table
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
      },
      pre_save_cmds = {
        function()
          -- Close all nvim-tree windows before saving session
          require("nvim-tree.api").tree.close()
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
