return {
  "rmagatti/auto-session",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = true,
      auto_session_enable_last_session = true,  -- enables restoring the last session
      auto_save_enabled = true,                 -- enables auto save
      auto_session_create_enabled = true,       -- enables creating new sessions
      auto_session_use_git_branch = true,       -- separate sessions per git branch
      log_level = "error",                      -- reduce log level to see if there are errors
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
      session_lens = {
        -- If you don't want the session-lens (telescope plugin for sessions), remove this table
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
      },
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>sr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
    keymap.set("n", "<leader>ss", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
    keymap.set("n", "<leader>sl", "<cmd>Telescope session-lens search_session<CR>", { desc = "List available sessions" })
  end,
}
