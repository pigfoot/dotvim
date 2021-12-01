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
"Plug 'arcticicestudio/nord-vim'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'

" Generic purpose
Plug 'tpope/vim-sensible'

" Development
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'luochen1990/rainbow'
Plug 'tpope/vim-surround'
Plug 'ntpeters/vim-better-whitespace'
Plug 'mbbill/undotree'
Plug 'justinmk/vim-sneak'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

if has('nvim')
  Plug 'neovim/nvim-lspconfig'        " Collection of configurations for built-in LSP client
  Plug 'hrsh7th/nvim-cmp'             " Autocompletion plugin
  Plug 'hrsh7th/cmp-nvim-lsp'         " LSP source for nvim-cmp
  Plug 'saadparwaiz1/cmp_luasnip'     " Snippets source for nvim-cmp
  Plug 'L3MON4D3/LuaSnip'             " Snippets plugin
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

if has_key(g:plugs, 'nord-vim')
  colorscheme nord
  " For tmux user, plese set the following option in .tmux.conf
  " set -g  default-terminal    "xterm-256color"
  " set -ga terminal-overrides  ",*256col*:Tc"
  if has("termguicolors")
    set termguicolors
  endif
endif

if has_key(g:plugs, 'lightline.vim')
  " Show readonly
  function! LightlineReadonly()
    return &readonly ? '' : ''
  endfunction

  " Show git branch
  function! LightlineFugitive()
    if exists('*fugitive#head')
      let branch = fugitive#head()
      return branch !=# '' ? ' '.branch : ''
    endif
    return ''
  endfunction

  " Git blame message
  function! LightlineGitBlame() abort
    let blame = get(b:, 'coc_git_blame', '')
    " return blame
    return winwidth(0) > 120 ? blame : ''
  endfunction

  " Get current funtion symbol
  function! CocCurrentFunction()
    let currentFunctionSymbol = get(b:, 'coc_current_function', '')
    return currentFunctionSymbol !=# '' ? " " .currentFunctionSymbol : ''
  endfunction

  let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch'],
    \             [ 'readonly', 'relativepath', 'modified' ],
    \             ['cocstatus', 'currentfunction' ] ],
    \   'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
    \              [ 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'fileformat', 'fileencoding', 'filetype' ], ['blame'] ]
    \ },
    \ 'component_function': {
    \   'readonly': 'LightlineReadonly',
    \   'gitbranch': 'LightlineFugitive',
    \   'cocstatus': 'coc#status',
    \   'blame': 'LightlineGitBlame',
    \   'currentfunction': 'CocCurrentFunction',
    \ },
    \ }

  " seperator
  " let g:lightline.separator = { 'left': '', 'right': '' }
  " let g:lightline.subseparator = { 'left': '', 'right': '' }

  " ALE linter info
  let g:lightline#ale#indicator_checking = "\uf110"
  let g:lightline#ale#indicator_warnings = "\uf071 "
  let g:lightline#ale#indicator_errors = "\uf05e "
  let g:lightline#ale#indicator_ok = "\uf00c"
  let g:lightline.component_expand = {
    \   'linter_checking': 'lightline#ale#checking',
    \   'linter_warnings': 'lightline#ale#warnings',
    \   'linter_errors': 'lightline#ale#errors',
    \   'linter_ok': 'lightline#ale#ok',
    \ }
  let g:lightline.component_type = {
    \   'linter_checking': 'left',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error',
    \   'linter_ok': 'left',
    \ }

  " tabline
  "set showtabline=2  " Show tabline
  "let g:lightline.tabline = {
    "\   'left': [ ['tabs'] ],
    "\   'right': [ ['close'] ]
    "\ }
  "let g:lightline.tab_component_function = {
    "\   'shortpath': 'ShortPath',
    "\}
  "let g:lightline.tab = {
    "\ 'active': [ 'tabnum', 'shortpath', 'modified' ],
    "\ 'inactive': [ 'tabnum', 'filename', 'modified' ] }

  function! ShortPath(n) abort
    " Partly copied from powerline code:
    " https://github.com/admc/dotfiles/blob/master/.vim/autoload/Powerline/Functions.vim#L25
    " Display a short path where the first directory is displayed with its
    " full name, and the subsequent directories are shortened to their
    " first letter, i.e. "/home/user/foo/foo/bar/baz.vim" becomes
    " "~/foo/f/b/baz.vim"
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let filename = expand('#'.buflist[winnr - 1].':t')
    if filename ==# ''
      return '[No Name]'
    endif

    let exclude_files = ['gitcommit', 'defx']
    for ft in exclude_files
      if ft ==# &filetype
        return filename
      endif
    endfor

    " Check if buffer is a terminal
    if &buftype ==# 'terminal'
      return filename
    endif

    let dirsep = has('win32') && ! &shellslash ? '\' : '/'
    let filepath = expand('%:p')
    if empty(filepath)
      return filename
    endif

    " This displays the shortest possible path, relative to ~ or the
    " current directory.
    let mod = (exists('+acd') && &acd) ? ':~:h' : ':~:.:h'
    let fpath = split(fnamemodify(filepath, mod), dirsep)
    let fpath_shortparts = map(fpath[1:], 'v:val[0]')
    let short_path = join(extend([fpath[0]], fpath_shortparts), dirsep) . dirsep
    if short_path == ('.' . dirsep)
      let short_path = ''
    endif
    return short_path . filename
  endfunction

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

if has_key(g:plugs, 'telescope.nvim')
  " Find files using Telescope command-line sugar.
  nnoremap <leader>ff <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>
endif

if has_key(g:plugs, 'nvim-cmp')
  lua require 'pf_nvim-cmp'
endif
