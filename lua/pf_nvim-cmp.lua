local cmp = require('cmp')
cmp.setup{
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    -- Add tab support
--  ['<Tab>'] = function(fallback)
--    if cmp.visible() then
--      cmp.select_next_item()
--    else
--      fallback()
--    end
--  end,
    ['<Tab>'] = cmp.mapping(function(fallback)
      if vim.fn['vsnip#jumpable'](1) == 1 then
        feedkey('<Plug>(vsnip-jump-next)', '')
      else
        local copilot_keys = vim.fn['copilot#Accept']()
        if copilot_keys ~= '' then
          vim.api.nvim_feedkeys(copilot_keys, 'i', true)
        else
          fallback()
        end
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'cmdline' },
  },
}
