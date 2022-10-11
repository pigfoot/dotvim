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

"if !has('nvim')
"  let my_plug_path = $HOME.'/.vim/autoload/plug.vim'
"else
"  let my_plug_path = $HOME.'/.local/share/nvim/site/autoload/plug.vim'
"endif

let my_plug_path    = $HOME.'/.vim/autoload/plug.vim'
let my_cache_path   = $HOME.'/.cache/vim'
let my_plugins_path = my_cache_path.'/plugged'

if empty(glob(my_plug_path))
  silent execute '!curl -fLo '.my_plug_path.' --create-dirs
    \  "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(my_plugins_path)

if !has('nvim')
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Scheme
Plug 'lifepillar/vim-solarized8'

" Generic purpose
Plug 'tpope/vim-sensible'

" Development
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'simrat39/rust-tools.nvim'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'luochen1990/rainbow'
Plug 'tpope/vim-surround'
Plug 'ntpeters/vim-better-whitespace'
Plug 'mbbill/undotree'
Plug 'justinmk/vim-sneak'

if has('nvim')
  " auto-completion engine
  Plug 'neovim/nvim-lspconfig'        " Collection of configurations for built-in LSP client
  Plug 'hrsh7th/nvim-cmp'             " Completion framework
  Plug 'hrsh7th/cmp-nvim-lsp'         " LSP completion source for nvim-cmp

  Plug 'hrsh7th/cmp-vsnip'            " Snippets source for nvim-cmp
  Plug 'hrsh7th/vim-vsnip'            " Snippets plugin
  Plug 'hrsh7th/vim-vsnip-integ'
  Plug 'onsails/lspkind-nvim'

  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'

  Plug 'jose-elias-alvarez/null-ls.nvim'

  " treesitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  " Fuzzy finder
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'

  Plug 'lukas-reineke/indent-blankline.nvim'
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
  " For tmux user, plese set the following option in .tmux.conf
  " set -g  default-terminal    "xterm-256color"
  " set -ga terminal-overrides  ",*256col*:Tc"
  if has("termguicolors") && has('gui_running')
    set termguicolors
  endif
endif

if has_key(g:plugs, 'vim-go')
  let g:go_bin_path = my_cache_path . '/gopath/bin'
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_types = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_extra_types = 1
  let g:go_highlight_build_constraints = 1
  let g:go_def_reuse_buffer = 1
  let g:go_gopls_enabled = 1
  let g:go_get_update = 0
endif

if has_key(g:plugs, 'rust-tools.nvim')
endif

if has_key(g:plugs, 'vim-signify')
  " :SignifyToggle to toggle enable/disable
endif

if has_key(g:plugs, 'vim-fugitive')
endif

if has_key(g:plugs, 'rainbow')
  " To disable it later via :RainbowToggle
  let g:rainbow_active = 1
endif

if has_key(g:plugs, 'vim-surround')
  " ys is 'you surround', e.g. ysiw<p>
  "   ================          =======     ==========================
  "   Old text                  Command     New text ~
  "   ================          =======     ==========================
  "   "Hello *world!"           ds"         Hello world!
  "   [123+4*56]/2              cs])        (123+456)/2
  "   "Look ma, I'm *HTML!"     cs"<q>      <q>Look ma, I'm HTML!</q>
  "   if *x>3 {                 ysW(        if ( x>3 ) {
  "   my $str = *whee!;         vllllS'     my $str = 'whee!';
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

if has_key(g:plugs, 'vim-sneak')
endif

if has_key(g:plugs, 'nvim-lspconfig')
  lua require 'pf_nvim-lspconfig'
endif

if has_key(g:plugs, 'nvim-cmp')
  lua require 'pf_nvim-cmp'
endif

if has_key(g:plugs, 'null-ls.nvim')
  lua require 'pf_null-ls'
endif
if has_key(g:plugs, 'nvim-treesitter')
  lua require 'pf_nvim-treesitter'
endif

if has_key(g:plugs, 'popup.nvim')
endif

if has_key(g:plugs, 'plenary.nvim')
endif

if has_key(g:plugs, 'telescope.nvim')
  " Find files using Telescope command-line sugar.
  nnoremap <leader>ff <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>
endif


if has_key(g:plugs, 'indent-blankline.nvim')
lua << EOF
  require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = true,
  }
EOF
endif
