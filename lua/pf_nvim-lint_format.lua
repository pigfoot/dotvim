require('lint').linters_by_ft = {
  -- typescript = {'eslint'},
  -- typescriptreact = {'eslint'},
  -- javascript = {'eslint_d'},
  -- javascriptreact = {'eslint'},
  lua = {'luacheck'},
  -- python = {'flake8'},
  bash = {'shellcheck'},
  sh = {'shellcheck'},
  terraform = {'tflint'},
  json = {'jsonlint'}
}

vim.api.nvim_create_autocmd({"BufWritePost"}, {
  callback = function()
    require("lint").try_lint()
  end
})

-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here and will be executed in order
    lua = {
      -- "formatter.filetypes.lua" defines default configurations for the
      -- "lua" filetype
      require("formatter.filetypes.lua"), -- You can also define your own configuration
      function()
        -- Supports conditional formatting
        if util.get_current_buffer_file_name() == "special.lua" then
          return nil
        end

        -- Full specification of configurations is down below and in Vim help files
        return {
          exe = "lua-format",
          args = {
            "--indent-width=2",
            "--continuation-indent-width=2",
            "--column-limit=100",
            "--chop-down-parameter",
            "--chop-down-table",
            "--chop-down-kv-table",
            "--no-keep-simple-control-block-one-line",
            "--no-keep-simple-function-one-line"
          },
          stdin = true
        }
      end
    },
    sh = {
      function()
        return {exe = "shfmt", args = {"-i", "4", "-ci"}, stdin = true}
      end
    },
    python = {
      function()
        return {exe = "black", args = {"-q", "-"}, stdin = true}
      end
    },
    terraform = {
      function()
        return {exe = "terraform", args = {"fmt", "-"}, stdin = true}
      end
    },
    yaml = {
      function()
        return {exe = "prettier", args = {"--parser=yaml"}, stdin = true}
      end
    },
    json = {
      function()
        return {
          exe = "prettier",
          args = {"--parser=json", "--no-bracket-spacing", "--print-width", "80"},
          stdin = true
        }
      end
    },
    javascript = {
      function()
        return {
          exe = "prettier",
          args = {"--parser=babel", "--no-bracket-spacing", "--print-width", "80"},
          stdin = true
        }
      end
    },

    -- Use the special "*" filetype for defining formatter configurations on any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any filetype
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    -- vim.lsp.buf.formatting_sync(nil, 1000)
    vim.api.nvim_command("FormatWrite")
  end
})
