require("mason").setup({})

local servers = {
  -- LSP
  "gopls",
  "pyright",
  "rust_analyzer",
  "typos_lsp",
  "yamlls", -- "yaml-language-server"
}

require("mason-tool-installer").setup {
  -- install not just can install LSP, but also can install lint.
  -- however it cannot to setup.
  ensure_installed = {
    -- Linter
    "jsonlint",
    "yamllint",
    -- table.unpack(servers) for lua > 5.1
    unpack(servers),
  },

  -- automatically install / update on startup. If set to false nothing
  -- will happen on startup. You can use :MasonToolsInstall or
  -- :MasonToolsUpdate to install tools and check for updates.
  -- Default: true
  run_on_start = true,

  -- Only attempt to install if 'debounce_hours' number of hours has
  -- elapsed since the last time Neovim was started. This stores a
  -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
  -- This is only relevant when you are using 'run_on_start'. It has no
  -- effect when running manually via ':MasonToolsInstall' etc....
  -- Default: nil
  debounce_hours = 5 -- at least 5 hours between attempts to install/update
}

require("mason-lspconfig").setup({})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- go.nvim setup
require('go').setup({
  go = 'go', -- go command, can be go[default] or go1.18beta1
  goimports = 'gopls', -- goimports command, can be gopls[default] or either goimports or golines if need to split long lines
  gofmt = 'gopls', -- gofmt through gopls: alternative is gofumpt, goimports, golines, gofmt, etc
  fillstruct = 'gopls' -- set to fillstruct if gopls fails to fill struct
})

-- Run gofmt + goimports on save
local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require('go.format').goimports()
  end,
  group = format_sync_grp
})

-- Require LSP config which we can use to attach gopls to the LSP client
local lspconfig = require 'lspconfig'
local utils = require 'lspconfig/util'

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
for _, server in pairs(servers) do
  if (server == 'gopls') then
    -- Set up the gopls configuration
    lspconfig[server].setup {
      cmd = {"gopls", "serve"},
      filetypes = {"go", "gomod"},
      root_dir = utils.root_pattern("go.work", "go.mod", ".git"),
      settings = {gopls = {analyses = {unusedparams = true}, staticcheck = true}},
      -- set tag function
      tag_func = require('go').tag,
      capabilities = capabilities,
    }
  elseif (server == 'pyright') then
    lspconfig[server].setup {
      settings = {
        pyright = {autoImportCompletion = true},
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = 'openFilesOnly',
            useLibraryCodeForTypes = true,
            typeCheckingMode = 'off'
          },
        }
      },
      capabilities = capabilities,
    }
  elseif (server == 'yamlls') then
    lspconfig[server].setup {
      -- cmd = {'yaml-language-server', '--stdio'},
      filetypes = {'yaml', 'yml'},
      root_dir = lspconfig.util.root_pattern(".git"),
      settings = {
        yaml = {
          schemas = {
            -- GitHub Actions workflow schema
            ["https://json.schemastore.org/github-workflow.json"] = "*.github/workflows/*",
            -- Docker Compose schema
            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "**/docker-compose.yaml"
          }
        }
      },
      capabilities = capabilities,
    }
  else
    -- the rest of server use default setup
    lspconfig[server].setup {
      capabilities = capabilities,
    }
  end
end
