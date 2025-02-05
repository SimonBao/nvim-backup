return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
      },
      format_on_save = function()
        -- Check for workspace setting
        if vim.g.format_on_save ~= nil then
          return vim.g.format_on_save
        end
        -- Default settings
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
      log_level = vim.log.levels.DEBUG,
      notify_on_error = true,
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        async = true,
        lsp_fallback = true,
        callback = function(err)
          if err then
            vim.notify("Format error: " .. vim.inspect(err), vim.log.levels.ERROR)
          end
        end,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
