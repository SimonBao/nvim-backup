return {
  "Hoffs/omnisharp-extended-lsp.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  lazy = true,  -- Load when needed
  ft = { "cs", "vb" },  -- Load for C# and VB.NET files
} 