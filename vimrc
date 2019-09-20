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
let my_plugins_path = my_cache_path . '/plugged'

if empty(glob(my_plug_path))
  silent execute '!curl -fLo ' . my_plug_path . ' --create-dirs
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
Plug 'vim-airline/vim-airline'

" Generic purpose
Plug 'tpope/vim-sensible'

" Development
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'mhinz/vim-signify'
Plug 'luochen1990/rainbow'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'ntpeters/vim-better-whitespace'
Plug 'mbbill/undotree'

call plug#end()

"---------------------------------------------------------------------------
" General Settings
"---------------------------------------------------------------------------
syntax enable

" tab setting {{
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
" }}

" autocmd {{ "
augroup common
  autocmd!
  autocmd FileType make set noexpandtab shiftwidth=4 softtabstop=0
augroup end
" }} autocmd "

" For tmux user, plese set the following option in .tmux.conf
" set -g  default-terminal    "tmux-256color"
" set -ga terminal-overrides  ",xterm-256color:Tc"
if has("termguicolors")
  "if !has('nvim')
    "" fix bug for vim
    "set t_8f=[38;2;%lu;%lu;%lum
    "set t_8b=[48;2;%lu;%lu;%lum
  "endif

  " enable true color for GUI
  if has('gui_running')
    set termguicolors
  endif
endif

"---------------------------------------------------------------------------
" Key mappings
"---------------------------------------------------------------------------
" set leader from default \\ to ,
let g:mapleader = ","

"---------------------------------------------------------------------------
"" PLUGIN SETTINGS
"---------------------------------------------------------------------------

if has_key(g:plugs, 'vim-solarized8')
  set background=dark
  colorscheme solarized8
endif

if has_key(g:plugs, 'vim-airline')
  let g:airline_powerline_fonts = 1
  let g:airline_detect_paste=1
  if !has('nvim')
    " To display the status line always
    set laststatus=2
  endif
endif

if has_key(g:plugs, 'coc.nvim')
  let $PATH .= ':' . my_cache_path . '/gopath/bin'
  let g:coc_global_extensions = [
    \'coc-css', 'coc-json', 'coc-go', 'coc-yaml'
    \]

  autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

  " Snippet completion {{
  inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  inoremap <silent><expr> <c-space> coc#refresh()
  inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  let g:coc_snippet_next = '<tab>'
  " }}
endif

if has_key(g:plugs, 'vim-go')
  let g:go_bin_path = my_cache_path . '/gopath/bin'
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_build_constraints = 1
  let g:go_fmt_command = 'gofumports'
  let g:go_def_mode = 'godef'
  let g:go_get_update = 0
endif

if has_key(g:plugs, 'ultisnips')
endif

if has_key(g:plugs, 'vim-snippets')
endif

if has_key(g:plugs, 'vim-signify')
endif

if has_key(g:plugs, 'rainbow')
  " To disable it later via :RainbowToggle
  let g:rainbow_active = 1
endif

if has_key(g:plugs, 'nerdcommenter')
  " <leader>cc         | Comment out the current line or text selected in visual mode
  " <leader>c<space>   | Toggles the comment state of the selected line(s)
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

if has_key(g:plugs, 'vim-repeat')
endif

if has_key(g:plugs, 'vim-better-whitespace')
endif

if has_key(g:plugs, 'undotree')
  let my_undodir = my_cache_path.'/.undodir'

  if !isdirectory(my_undodir)
    silent call mkdir (my_undodir, 'p')
  endif
  exec 'set undodir='.my_undodir
  set undofile
endif
