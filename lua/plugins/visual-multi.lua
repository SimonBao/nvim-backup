return {
  {
    "mg979/vim-visual-multi",
    lazy = false,
    init = function()
      -- Disable default mappings to prevent conflicts
      vim.g.VM_default_mappings = 0
      
      -- Set leader key for visual-multi
      vim.g.VM_leader = '\\'

      -- Set your preferred mappings
      vim.g.VM_maps = {
        ["Find Under"] = "<C-m>",
        ["Find Subword Under"] = "<C-m>",
        ["Select All"] = "<C-m>A",
        ["Skip Region"] = "<C-x>",
        ["Remove Region"] = "<C-p>",
      }
    end,
  }
} 