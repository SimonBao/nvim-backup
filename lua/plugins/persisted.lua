return {
  "olimorris/persisted.nvim",
  lazy = false,  -- We want this to load at startup
  opts = {
    save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- Directory where session files are saved
    use_git_branch = true,  -- Session per git branch
    autoload = true,  -- Automatically load session for the cwd
    should_autosave = function()  -- Don't autosave if dashboard/alpha is open
      if vim.bo.filetype == "alpha" then
        return false
      end
      return true
    end,
    telescope = {  -- Telescope configuration
      mappings = {
        copy_session = "<C-c>",
        change_branch = "<C-b>",
        delete_session = "<C-d>",
      },
      icons = {
        selected = " ",
        dir = "  ",
        branch = " ",
      },
    },
  },
  config = function(_, opts)
    require("persisted").setup(opts)
    require("telescope").load_extension("persisted")  -- Load telescope extension

    -- Update keymaps for sessions
    local map = vim.keymap.set
    map("n", "<leader>fsf", "<cmd>Telescope persisted<CR>", { desc = "Find sessions" })
    map("n", "<leader>fss", "<cmd>SessionSave<CR>", { desc = "Save session" })
    map("n", "<leader>fsl", "<cmd>SessionLoad<CR>", { desc = "Load session" })
    map("n", "<leader>fsd", "<cmd>SessionDelete<CR>", { desc = "Delete session" })
  end,
} 