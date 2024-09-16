require('copilot').setup({
  panel = {
    enabled = false,
    auto_refresh = false,
    keymap = {jump_prev = "[[", jump_next = "]]", accept = "<CR>", refresh = "gr", open = "<M-CR>"},
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4
    }
  },
  suggestion = {
    enabled = false,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = "<Tab>",
      accept_word = false,
      accept_line = false,
      next = "‘",
      prev = "“",
      dismiss = "<C-]>"
    }
  },
  filetypes = {
    yaml = true,
    markdown = true,
    help = true,
    gitcommit = true,
    gitrebase = true,
    hgcommit = true,
    svn = true,
    cvs = true,
    ["."] = true
  },
  copilot_node_command = 'node', -- Node.js version must be > 18.x
  server_opts_overrides = {}
})

require("copilot_cmp").setup({
  event = { "InsertEnter", "LspAttach" },
  fix_pairs = true,
})
