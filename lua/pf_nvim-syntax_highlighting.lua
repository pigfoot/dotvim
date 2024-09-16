-- syntax highlighting
require('nvim-treesitter.configs').setup {
  -- A list of parser names, or 'all'
  ensure_installed = {
    -- programming languages
    "bash",
    "go",
    "javascript",
    "python",
    "rust",
    "sql",
    -- text formats
    "comment",
    "diff",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "json",
    "markdown",
    "yaml",
    "yaml"
  },

  -- Install parsers synchronously (only used with ensure_installed)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,
    highlight = {
      -- `false` will disable the whole extension
      enable = true
    }
}