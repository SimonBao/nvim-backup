-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "pyright" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

-- C# (OmniSharp) setup
lspconfig.omnisharp.setup {
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)
    
    -- Add OmniSharp specific keymaps here
    local map = vim.keymap.set
    map("n", "<leader>ct", "<cmd>lua require('omnisharp_extended').telescope_lsp_definitions()<CR>", { buffer = bufnr, desc = "Goto Definition" })
    map("n", "<leader>ci", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = bufnr, desc = "Goto Implementation" })
    map("n", "<leader>cr", "<cmd>lua vim.lsp.buf.references()<CR>", { buffer = bufnr, desc = "Find References" })
  end,
  capabilities = nvlsp.capabilities,
  
  -- OmniSharp settings
  cmd = { vim.fn.expand("$HOME/.local/share/nvim-tools/omnisharp/OmniSharp") },  -- Path to our installed OmniSharp
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
  enable_import_completion = true,
  
  -- Additional settings
  handlers = {
    ["textDocument/definition"] = require('omnisharp_extended').handler,
  },
}
