return {
  'rmagatti/auto-session',
  lazy = false,
  opts = {
    log_level = "error",
    auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    auto_restore = true,
    auto_save = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    session_lens = {
      load_on_setup = false,
    },
  },
  keys = {
    { "<leader>fss", "<cmd>SessionSave<CR>", desc = "Save session" },
    { "<leader>fsr", "<cmd>SessionRestore<CR>", desc = "Restore session" },
    { "<leader>fsd", "<cmd>SessionDelete<CR>", desc = "Delete session" },
    { "<leader>fsf", "<cmd>SessionSearch<CR>", desc = "Find session" },
  },
} 