-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local configs = require("nvchad.configs.lspconfig")

local on_attach = function(client, bufnr)
  -- Add this at the start of on_attach for debugging
  vim.notify(string.format("LSP %s attached to buffer %d", client.name, bufnr))

  -- Call NvChad's default on_attach first
  configs.on_attach(client, bufnr)

  -- Enhanced documentation commands
  local current_preview_win = nil
  
  -- Function to show full documentation
  local function show_full_doc(cword)
    local pydoc_cmd = string.format("python -m pydoc %s", cword)
    local pydoc_output = vim.fn.system(pydoc_cmd)
    
    -- Close any existing preview window
    if current_preview_win and vim.api.nvim_win_is_valid(current_preview_win) then
      vim.api.nvim_win_close(current_preview_win, true)
      current_preview_win = nil
    end
    
    if vim.v.shell_error == 0 then
      vim.schedule(function()
        local win_id = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
          relative = 'editor',
          width = math.floor(vim.o.columns * 0.9),    -- 90% of screen width
          height = math.floor(vim.o.lines * 0.85),    -- 85% of screen height
          row = math.floor(vim.o.lines * 0.05),       -- 5% from top
          col = math.floor(vim.o.columns * 0.05),     -- 5% from left
          style = 'minimal',
          border = 'rounded',
          title = "Python Documentation",
          title_pos = "center",
        })
        
        local buf = vim.api.nvim_win_get_buf(win_id)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(pydoc_output, "\n"))
        vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
        vim.api.nvim_buf_set_option(buf, 'modifiable', false)
        vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
        vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
        
        -- Enable normal mode navigation
        vim.api.nvim_win_set_option(win_id, 'wrap', true)
        vim.api.nvim_win_set_option(win_id, 'cursorline', true)
        
        -- Keymaps
        local opts = { buffer = buf, noremap = true, silent = true }
        vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win_id, true) end, opts)
        vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win_id, true) end, opts)
        vim.keymap.set('n', '<CR>', function() vim.api.nvim_win_close(win_id, true) end, opts)
        
        -- Navigation keymaps
        vim.keymap.set('n', 'j', 'j', opts)
        vim.keymap.set('n', 'k', 'k', opts)
        vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
        vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
        vim.keymap.set('n', 'G', 'G', opts)
        vim.keymap.set('n', 'gg', 'gg', opts)
        vim.keymap.set('n', '/', '/', opts)
        vim.keymap.set('n', 'n', 'n', opts)
        vim.keymap.set('n', 'N', 'N', opts)
        
        vim.api.nvim_win_set_cursor(win_id, {1, 0})

        -- Add resize keymaps
        local opts = { buffer = buf, noremap = true, silent = true }
        -- Vertical resize
        vim.keymap.set('n', '<C-Up>', function()
          local height = vim.api.nvim_win_get_height(win_id)
          vim.api.nvim_win_set_height(win_id, height + 2)
        end, opts)
        vim.keymap.set('n', '<C-Down>', function()
          local height = vim.api.nvim_win_get_height(win_id)
          vim.api.nvim_win_set_height(win_id, height - 2)
        end, opts)
        -- Horizontal resize
        vim.keymap.set('n', '<C-Left>', function()
          local width = vim.api.nvim_win_get_width(win_id)
          vim.api.nvim_win_set_width(win_id, width - 2)
        end, opts)
        vim.keymap.set('n', '<C-Right>', function()
          local width = vim.api.nvim_win_get_width(win_id)
          vim.api.nvim_win_set_width(win_id, width + 2)
        end, opts)
        -- Reset size
        vim.keymap.set('n', '<C-=>',  function()
          vim.api.nvim_win_set_width(win_id, math.floor(vim.o.columns * 0.9))
          vim.api.nvim_win_set_height(win_id, math.floor(vim.o.lines * 0.85))
        end, opts)
      end)
    end
  end

  -- Quick documentation (K)
  vim.keymap.set("n", "K", function()
    local filetype = vim.bo.filetype
    local cword = vim.fn.expand('<cword>')

    if filetype == "python" then
      local hover_ok = pcall(vim.lsp.buf.hover)
      if not hover_ok then
        -- If LSP hover fails, show minimal pydoc
        local pydoc_cmd = string.format("python -m pydoc %s", cword)
        local pydoc_output = vim.fn.system(pydoc_cmd)
        
        if vim.v.shell_error == 0 then
          local lines = vim.split(pydoc_output, "\n")
          local quick_docs = {}
          for i = 1, math.min(3, #lines) do
            table.insert(quick_docs, lines[i])
          end
          _, current_preview_win = vim.lsp.util.open_floating_preview(quick_docs, "python", {
            border = "rounded",
            max_width = 80,
          })
        end
      end
    else
      -- Non-Python logic
      if client and client.server_capabilities and client.server_capabilities.hoverProvider then
        vim.lsp.buf.hover()
      else
        local ok = pcall(vim.cmd, 'help ' .. cword)
        if not ok then
          local hover_ok = pcall(vim.lsp.buf.hover)
          if not hover_ok then
            vim.notify("No documentation found for: " .. cword, vim.log.levels.INFO)
          end
        end
      end
    end
  end, { buffer = bufnr, noremap = true, silent = true, desc = "Show quick documentation" })

  -- Full documentation (Ctrl+K)
  vim.keymap.set("n", "<C-k>", function()
    local filetype = vim.bo.filetype
    local cword = vim.fn.expand('<cword>')
    
    if filetype == "python" then
      show_full_doc(cword)
    end
  end, { buffer = bufnr, noremap = true, silent = true, desc = "Show full documentation" })

  -- LSP keymaps
  local opts = { noremap = true, silent = true }
  
  -- Additional LSP mappings
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

  -- Add rename specific keymaps
  if client.server_capabilities.renameProvider then
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, 
      { buffer = bufnr, desc = "Rename symbol" })
  end

  -- Add workspace symbol search
  if client.server_capabilities.workspaceSymbolProvider then
    vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, 
      { buffer = bufnr, desc = "Search workspace symbols" })
  end
end

local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  configs.capabilities or {}
)

local lspconfig = require "lspconfig"

-- Configure lua language server with enhanced settings
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

-- Remove the duplicate servers list and merge with custom servers
local servers = { 
  "html", 
  "cssls",
  "pyright",
}

-- Keep one pyright configuration
lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
        completeFunctionParens = true,
        inlayHints = {
          functionReturnTypes = true,
          variableTypes = true,
        },
      },
    },
  },
  before_init = function(_, config)
    local python_path = vim.fn.exepath("python") or vim.fn.exepath("python3")
    if python_path ~= "" then
      config.settings.python.pythonPath = python_path
    end
  end,
}

-- Configure TypeScript with ts_ls (the new name)
require("lspconfig").typescript_language_server.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" }
}

-- Configure other servers
for _, lsp in ipairs(servers) do
  if lsp ~= "pyright" then  -- Skip pyright as it's configured above
    lspconfig[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end
end
