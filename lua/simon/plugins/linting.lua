return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Keymaps for toggling linting
    vim.keymap.set("n", "<leader>td", function()
      if vim.diagnostic.is_disabled() then
        vim.diagnostic.enable()
        vim.notify("Diagnostics enabled", vim.log.levels.INFO)
      else
        vim.diagnostic.disable()
        vim.notify("Diagnostics disabled", vim.log.levels.INFO)
      end
    end, { desc = "Toggle diagnostics globally" })

    vim.keymap.set("n", "<leader>tD", function()
      local buf = vim.api.nvim_get_current_buf()
      if vim.diagnostic.is_disabled(buf) then
        vim.diagnostic.enable(buf)
        vim.notify("Diagnostics enabled for current buffer", vim.log.levels.INFO)
      else
        vim.diagnostic.disable(buf)
        vim.notify("Diagnostics disabled for current buffer", vim.log.levels.INFO)
      end
    end, { desc = "Toggle diagnostics for current buffer" })

    -- Manual lint
    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
