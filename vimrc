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
let my_plugins_path = $HOME.'/.cache/vim/plugged'

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
Plug 'altercation/vim-colors-solarized'
Plug 'itchyny/lightline.vim'

" Generic purpose
Plug 'tpope/vim-sensible'

" Development
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'airblade/vim-gitgutter'
Plug 'luochen1990/rainbow'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'ntpeters/vim-better-whitespace'

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

"---------------------------------------------------------------------------
" Key mappings
"---------------------------------------------------------------------------
" set leader from default \\ to ,
let g:mapleader = ","

"---------------------------------------------------------------------------
"" PLUGIN SETTINGS
"---------------------------------------------------------------------------

if has_key(g:plugs, 'vim-colors-solarized')
  if &t_Co >= 256
    try
      set background=dark
      let g:solarized_termcolors=256
      let g:solarized_termtrans=0
      colorscheme solarized
    catch
      colorscheme desert
    endtry
  else
    colorscheme desert
  endif
endif

if has_key(g:plugs, 'lightline.vim')
  let g:lightline = { 'colorscheme': 'wombat' }
  if !has('nvim')
    " To display the status line always
    set laststatus=2
  endif
endif

if has_key(g:plugs, 'coc.nvim')
  let $PATH .= ':' . my_plugins_path . '/../gopath/bin'
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
  let g:go_bin_path = my_plugins_path . '/../gopath/bin'
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

if has_key(g:plugs, 'vim-gitgutter')
  " let SignColumn background is the same as what jellybeans provides
  let g:gitgutter_highlight_lines = 1

  " To turn off vim-gitgutter by default
  "let g:gitgutter_enabled = 0

  " To turn off signs by default
  "let g:gitgutter_signs = 0

  " Disable sign column
  "set signcolumn=yes
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
