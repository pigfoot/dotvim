require('nvim-treesitter.configs').setup ({
  ensure_installed = { "go", "lua", "rust", "toml" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,
  },
  ident = { enable = true },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
})

require('nvim-treesitter.highlight')
-- use below replace  local hlmap = vim.treesitter.TSHighlighter.hl_map
local hlmap = vim.treesitter.highlighter.hl_map

--Misc
hlmap.error = nil
hlmap["punctuation.delimiter"] = "Delimiter"
hlmap["punctuation.bracket"] = nil
