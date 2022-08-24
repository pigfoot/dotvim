local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
--local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
local servers = { 'gopls', 'pylsp', 'rust_analyzer' }
for _, lsp in ipairs(servers) do
  if (lsp == 'gopls') then
    lspconfig[lsp].setup {
      cmd = {
        vim.g.go_bin_path .. '/gopls'
      },
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
    }
  elseif (lsp == 'rust_analyzer') then
    lspconfig[lsp].setup {
      on_attach = on_attach,
      settings = {
        ["rust-analyzer"] = {
          -- enable clippy on save
          checkOnSave = {
            command = "clippy"
          },
        }
      }
    }
  else
    lspconfig[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
    }
  end
end
