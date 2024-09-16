local cmp = require('cmp')
local luasnip = require("luasnip")
local lspkind = require('lspkind')

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

cmp.setup({
  -- Configuration
  -- sources are used to define where the suggestions come from
  sources = {
    {name = 'luasnip'},
    {name = 'copilot'},
    {name = 'nvim_lsp'},
    {name = 'path'},
    {name = 'buffer'},
    {name = 'treesitter'},
    {name = 'spell'},
    {name = 'tags'},
  },

  --snippet = {
  --  expand = function(args)
  --    luasnip.lsp_expand(args.body)
  --  end
  --},

  -- Window
  -- The window configuration is used to define the appearance of the completion menu
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
    prompt = cmp.config.window.bordered()
  },

  -- Formatting
  -- The formatting configuration is used to define the appearance of the completion menuone
  formatting = {
    fields = {'abbr', 'kind', 'menu'},
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,  -- max width of the completion menu
      ellipsis = '…', -- show ellipsis when the item is too long
      symbol_map = {
        Copilot = "",
      },
    }),

    -- The completion menu will show the kind of the item
    -- The function below will be called before any actual modifications from lspkind
    before = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
        buffer = "[Buffer]",
        treesitter = "[TS]",
        spell = "[Spell]",
        tags = "[Tags]",
        calc = "[Calc]",
        emoji = "[Emoji]",
        minuet = "[Copilot]",
        luasnip = "[Snip]",
        path = "[Path]"
      })[entry.source.name]
      return vim_item
    end
  },

  -- Mapping
  -- The mapping table is used to define the keybindings for the completion menu
  mapping = {
    -- Downward will select the current item
    ['<Down>'] = cmp.mapping.select_next_item(),
    -- Upward will select the previous item
    ['<Up>'] = cmp.mapping.select_prev_item(),
    -- Ctrl+d will scroll down the list
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    -- Ctrl+u will scroll up the list
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    -- Right arrow will close the completion menu
    ['<Right>'] = cmp.mapping.close(),
    -- CR (enter or return) will confirm the selection
    ['<CR>'] = cmp.mapping.confirm({
      -- behavior = cmp.ConfirmBehavior.Replace,
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    -- Prevents the completion menu from appearing when typing <Tab>
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
      else
        fallback()
      end
    end)
  },

  sorting = {
    priority_weight = 2,
    comparators = {
      require("copilot_cmp.comparators").prioritize,
      require("copilot_cmp.comparators").score,

      -- Below is the default comparator list and order for nvim-cmp
      cmp.config.compare.offset,
      -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order
    }
  }
})
