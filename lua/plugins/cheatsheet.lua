return {
  {
    'sudormrfbin/cheatsheet.nvim',
    lazy = false,
    config = function()
      local cheatsheet = require('cheatsheet')
      cheatsheet.setup({
        bundled_cheatsheets = true,
        bundled_plugin_cheatsheets = true,
        include_only_installed_plugins = true,
        -- Filter out nerdfonts from the bundled cheatsheets
        bundled_cheatsheet_filter = function(cheatsheet_name)
          return not cheatsheet_name:match(".*nerd.*") 
            and not cheatsheet_name:match(".*font.*")
        end,
      })
    end,
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
    },
  }
}
