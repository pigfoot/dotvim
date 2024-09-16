"---------------------------------------------------------------------------
" Basic Settings
"---------------------------------------------------------------------------
if &compatible
  set nocompatible
endif

filetype plugin indent on

"---------------------------------------------------------------------------
" Plugins Settings
"---------------------------------------------------------------------------

" Automatic installation for vim-plug

if !has('nvim')
  let my_plug_path = $HOME.'/.vim/autoload/plug.vim'
else
  let my_plug_path = getenv('XDG_DATA_HOME') ?? $HOME . '/.local/share'
  let my_plug_path = my_plug_path . '/nvim/site/autoload/plug.vim'
endif

let my_cache_path   = getenv('XDG_CACHE_HOME') ?? $HOME . '/.cache/nvim'
let my_plugins_path = my_cache_path .'/plugged'

if empty(glob(my_plug_path))
  silent execute '!curl -fLo '.my_plug_path.' --create-dirs
    \  "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(my_plugins_path)

Plug 'lifepillar/vim-solarized8'

" Generic purpose
Plug 'tpope/vim-sensible'

" Development - General
Plug 'ntpeters/vim-better-whitespace'
Plug 'mbbill/undotree'

if has('nvim')

  " package manager for Neovim
  Plug 'williamboman/mason.nvim'
  Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'

  " LSP
  Plug 'neovim/nvim-lspconfig'        " Collection of configurations for built-in LSP client
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'nvim-lua/lsp-status.nvim'

  " auto-completion engine
  Plug 'hrsh7th/nvim-cmp'             " Completion framework
  Plug 'hrsh7th/cmp-nvim-lsp'         " LSP completion source for nvim-cmp
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'onsails/lspkind-nvim'

  " Snippet Engine and sources
  Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'rafamadriz/friendly-snippets'

  " Copilot
  Plug 'zbirenbaum/copilot.lua'
  Plug 'zbirenbaum/copilot-cmp'

  " Go
  Plug 'ray-x/go.nvim'
  Plug 'ray-x/guihua.lua' " recommended if need floating window support

  " Syntax highlighting
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  " Linting and Formatter
  Plug 'mfussenegger/nvim-lint'
  Plug 'mhartington/formatter.nvim'

  " status line
  Plug 'nvim-lualine/lualine.nvim'
  " If you want to have icons in your statusline choose one of these
  Plug 'kyazdani42/nvim-web-devicons'

endif

call plug#end()

"---------------------------------------------------------------------------
" General Settings
"---------------------------------------------------------------------------
syntax enable

" tab setting {{
set expandtab           " et:  expand tab through space [def:1]
set shiftwidth=4        " sw:  space count for shift [def:8]
set tabstop=4           " ts:  one tab contain space count [def:8]
set softtabstop=4       " sts: for et, space count that backspace would delete [def:0]
"set smarttab           " sta: line begin to insert sw space, otherwise insert ts space [def:0 but 1 in vim-sensible]
" }}

" misc {{ "
set copyindent          " copy the previous indentation on autoindenting
set ignorecase          " ignore case when searching
set smartcase           " ignore case if search pattern is all lowercase,case-sensitive otherwise
set nowrap              " don't wrap lines
set noswapfile          " disabling swap files creation

" }} "

" autocmd {{ "
augroup common
  autocmd!

  " tab setting
  autocmd FileType Makefile setlocal noexpandtab shiftwidth=4 softtabstop=0
  autocmd FileType vim      setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

  " others

augroup end
" }} autocmd (filetype) "

"---------------------------------------------------------------------------
" Key mappings
"---------------------------------------------------------------------------
" set leader from default \\ to ,
let g:mapleader = ","

"---------------------------------------------------------------------------
"" PLUGIN SETTINGS
"---------------------------------------------------------------------------

if has_key(g:plugs, 'vim-solarized8')
  colorscheme solarized8
  set background=dark
  " For tmux user, please set the following option in .tmux.conf
  " set -g  default-terminal    "xterm-256color"
  " set -ga terminal-overrides  ",*256col*:Tc"
  if has("termguicolors") && has('gui_running')
    set termguicolors
  endif
endif

if has_key(g:plugs, 'vim-sensible')
endif

if has_key(g:plugs, 'vim-better-whitespace')
  let g:strip_whitespace_on_save = 1
  autocmd FileType markdown EnableWhitespace  " markdown is not enable by default
endif

if has_key(g:plugs, 'undotree')
  let my_undodir = my_cache_path.'/.undodir'

  if !isdirectory(my_undodir)
    silent call mkdir (my_undodir, 'p')
  endif
  exec 'set undodir='.my_undodir
  set undofile
endif

if has_key(g:plugs, 'mason.nvim')
  \ && has_key(g:plugs, 'mason-tool-installer.nvim')
  \ && has_key(g:plugs, 'nvim-lspconfig')
  \ && has_key(g:plugs, 'mason-lspconfig.nvim')
  \ && has_key(g:plugs, 'go.nvim')
  \ && has_key(g:plugs, 'guihua.lua')
  lua require 'pf_nvim-lspconfig'
endif

if has_key(g:plugs, 'mason.nvim')
  \ && has_key(g:plugs, 'nvim-cmp')
  \ && has_key(g:plugs, 'cmp-nvim-lsp')
  \ && has_key(g:plugs, 'LuaSnip')
  \ && has_key(g:plugs, 'cmp_luasnip')
  \ && has_key(g:plugs, 'lspkind-nvim')
  \ && has_key(g:plugs, 'copilot.lua')
    lua require 'pf_nvim-cmp'
endif

if has_key(g:plugs, 'LuaSnip')
  \ && has_key(g:plugs, 'friendly-snippets')
  lua require('luasnip.loaders.from_vscode').lazy_load()
endif

if has_key(g:plugs, 'copilot.lua')
  \ && has_key(g:plugs, 'copilot-cmp')
  lua require 'pf_nvim-copilot'
endif

if has_key(g:plugs, 'nvim-treesitter')
  lua require 'pf_nvim-syntax_highlighting'
endif

if has_key(g:plugs, 'nvim-lint')
  \ && has_key(g:plugs, 'formatter.nvim')
  lua require 'pf_nvim-lint_format'
endif

if has_key(g:plugs, 'lualine.nvim')
  lua require('lualine').setup({})
endif

if has_key(g:plugs, 'nvim-web-devicons')
endif
