-- Common for completion  ################################################
-- Set completeopt to have a better completion experience (default: menu,preview)
-- :help completeopt
--    menuone: popup even when there's only one match
--    noinsert: Do not insert text until a selection is made
--    noselect: Do not select, force user to select one from the menu
-- no lua: set completeopt+=menuone,noinsert,noselect
vim.opt.completeopt = vim.opt.completeopt + { 'menuone', 'noinsert', 'noselect' }

-- shortness: avoid showing extra messages when using completion
-- no lua: set shortmess+=c
vim.opt.shortmess = vim.opt.shortmess + { c = true}

-- updatetime: set updatetime for CursorHold
-- no lua: set updatetime=300
vim.api.nvim_set_option('updatetime', 300)

-- Show diagnostic popup on cursor hold
-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error
-- Show inlay_hints more frequently
vim.cmd([[
  "set signcolumn=yes
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- LSP setting ##########################################################
local lspconfig = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Capabilities
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '1gD', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
end

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
--local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
local servers = { 'clangd', 'gopls', 'pylsp', 'rust-tools' }
for _, lsp in ipairs(servers) do
  if (lsp == 'gopls') then
    lspconfig[lsp].setup ({
      cmd = {
        vim.g.go_bin_path .. '/gopls'
      },
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
    })
  elseif (lsp == 'rust_analyzer') then
    lspconfig[lsp].setup ({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = { -- enable clippy on save
          checkOnSave = {
            command = "clippy"
          },
        }
      }
    })
  elseif (lsp == 'rust-tools') then
    local rt = require("rust-tools")
    rt.setup({
      server = {
        on_attach = function(client, bufnr)
          client.resolved_capabilities.document_formatting = false
          on_attach(client, bufnr)
        end,
        settings = {
          ["rust-analyzer"] = { -- enable clippy on save
            checkOnSave = {
              command = "clippy"
            },
          },
        }
      }
    })
  else
    lspconfig[lsp].setup ({
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
    })
  end
end
