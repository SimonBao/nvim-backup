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
  local function show_full_doc(cword, filetype)
    if filetype == "python" then
      -- Python-specific documentation using pydoc
      local pydoc_cmd = string.format("python -m pydoc %s", cword)
      local pydoc_output = vim.fn.system(pydoc_cmd)
      return pydoc_output, vim.v.shell_error == 0
    else
      -- For other languages, use LSP hover with enhanced display
      local params = vim.lsp.util.make_position_params()
      local result = vim.lsp.buf_request_sync(0, 'textDocument/hover', params, 1000)
      
      if result and result[1] then
        local hover = result[1].result
        if hover and hover.contents then
          local contents = hover.contents
          if type(contents) == 'table' then
            if contents.value then
              return contents.value, true
            elseif contents.language then
              return contents.language, true
            end
          end
          return tostring(contents), true
        end
      end
      return nil, false
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
          local buf, win = vim.lsp.util.open_floating_preview(quick_docs, "python", {
            border = "rounded",
            max_width = 80,
          })
          
          -- Add keymaps for quick docs window
          local opts = { buffer = buf, noremap = true, silent = true }
          vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end, opts)
          vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win, true) end, opts)
          vim.keymap.set('n', '<CR>', function() vim.api.nvim_win_close(win, true) end, opts)
        end
      end
    else
      -- Non-Python logic with keymaps
      if client and client.server_capabilities and client.server_capabilities.hoverProvider then
        local buf, win = vim.lsp.buf.hover()
        if buf and win then
          -- Add keymaps for LSP hover window
          local opts = { buffer = buf, noremap = true, silent = true }
          vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end, opts)
          vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win, true) end, opts)
          vim.keymap.set('n', '<CR>', function() vim.api.nvim_win_close(win, true) end, opts)
        end
      end
    end
  end, { buffer = bufnr, noremap = true, silent = true, desc = "Show quick documentation" })

  -- Full documentation (Ctrl+K)
  vim.keymap.set("n", "<C-k>", function()
    local filetype = vim.bo.filetype
    local cword = vim.fn.expand('<cword>')
    
    local doc_content, success = show_full_doc(cword, filetype)
    if success and doc_content then
      vim.schedule(function()
        local win_id = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
          relative = 'editor',
          width = math.floor(vim.o.columns * 0.9),
          height = math.floor(vim.o.lines * 0.85),
          row = math.floor(vim.o.lines * 0.05),
          col = math.floor(vim.o.columns * 0.05),
          style = 'minimal',
          border = 'rounded',
          title = string.format("Documentation for %s", cword),
          title_pos = "center",
        })
        
        local buf = vim.api.nvim_win_get_buf(win_id)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(doc_content, "\n"))
        vim.api.nvim_buf_set_option(buf, 'filetype', filetype)
        vim.api.nvim_buf_set_option(buf, 'modifiable', false)
        
        -- Add keymaps to close the window
        local opts = { buffer = buf, noremap = true, silent = true }
        vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win_id, true) end, opts)
        vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win_id, true) end, opts)
        vim.keymap.set('n', '<CR>', function() vim.api.nvim_win_close(win_id, true) end, opts)
      end)
    else
      vim.notify("No documentation found for: " .. cword, vim.log.levels.INFO)
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

-- Configure TypeScript LSP
local util = require "lspconfig.util"

require("lspconfig").ts_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
  single_file_support = true,
  init_options = {
    hostInfo = "neovim",
    preferences = {
      includeInlayParameterNameHints = "all",
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
    },
  }
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
