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
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
else
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
endif

" Defx
Plug 'kristijanhusak/defx-git'
Plug 'kristijanhusak/defx-icons'

" Scheme
Plug 'liaoishere/vim-one'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'

" Generic purpose
Plug 'tpope/vim-sensible'

" Development
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'SidOfc/mkdx'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'luochen1990/rainbow'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'ntpeters/vim-better-whitespace'
Plug 'mbbill/undotree'
Plug 'justinmk/vim-sneak'

" coc relate
Plug 'neoclide/coc.nvim',  {'branch': 'release'}
Plug 'neoclide/coc-json',  {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-yaml',  {'do': 'yarn install --frozen-lockfile'}

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

if has_key(g:plugs, 'vim-one')
  colorscheme one
  set background=dark
  let g:one_allow_italics = 1
  " For tmux user, plese set the following option in .tmux.conf
  " set -g  default-terminal    "tmux-256color"
  " set -ga terminal-overrides  ",xterm-256color:Tc"
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
  set showtabline=2  " Show tabline
  let g:lightline.tabline = {
    \   'left': [ ['tabs'] ],
    \   'right': [ ['close'] ]
    \ }
  let g:lightline.tab_component_function = {
    \   'shortpath': 'ShortPath',
    \}
  let g:lightline.tab = {
    \ 'active': [ 'tabnum', 'shortpath', 'modified' ],
    \ 'inactive': [ 'tabnum', 'filename', 'modified' ] }

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
  let g:go_fmt_command = 'gofumports'
  let g:go_get_update = 0
endif

if has_key(g:plugs, 'mkdx')
endif

if has_key(g:plugs, 'ultisnips')
endif

if has_key(g:plugs, 'vim-snippets')
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

if has_key(g:plugs, 'defx.nvim')
  map <silent> - :Defx<CR>

  call defx#custom#column('icon', {
    \ 'directory_icon': '▸',
    \ 'opened_icon': '▾',
    \ 'root_icon': ' ',
    \ })
  call defx#custom#column('filename', {
    \ 'min_width': 40,
    \ 'max_width': 40,
    \ })
  call defx#custom#column('mark', {
    \ 'readonly_icon': '✗',
    \ 'selected_icon': '✓',
    \ })
  call defx#custom#option('_', {
    \ 'winwidth': 35,
    \ 'columns': 'git:mark:indent:icons:filename:type',
    \ 'split': 'vertical',
    \ 'direction': 'topleft',
    \ 'show_ignored_files': 0,
    \ 'buffer_name': '',
    \ 'toggle': 1,
    \ 'resume': 1
    \ })

  " Avoid the white space highting issue
  autocmd FileType defx match ExtraWhitespace /^^/

  " Keymap in defx
  autocmd FileType defx call s:defx_my_settings()
  function! s:defx_my_settings() abort
    IndentLinesDisable
    setl nospell
    setl signcolumn=no
    setl nonumber
    nnoremap <silent><buffer><expr> <CR>
    \ defx#is_directory() ?
    \ defx#do_action('open_or_close_tree') :
    \ defx#do_action('drop',)
    nmap <silent><buffer><expr> <2-LeftMouse>
    \ defx#is_directory() ?
    \ defx#do_action('open_or_close_tree') :
    \ defx#do_action('drop',)
    nnoremap <silent><buffer><expr> s defx#do_action('drop', 'split')
    nnoremap <silent><buffer><expr> v defx#do_action('drop', 'vsplit')
    nnoremap <silent><buffer><expr> t defx#do_action('drop', 'tabe')
    nnoremap <silent><buffer><expr> o defx#do_action('open_tree')
    nnoremap <silent><buffer><expr> O defx#do_action('open_tree_recursive')
    nnoremap <silent><buffer><expr> C defx#do_action('copy')
    nnoremap <silent><buffer><expr> P defx#do_action('paste')
    nnoremap <silent><buffer><expr> M defx#do_action('rename')
    nnoremap <silent><buffer><expr> D defx#do_action('remove_trash')
    nnoremap <silent><buffer><expr> A defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> U defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select')
    nnoremap <silent><buffer><expr> R defx#do_action('redraw')
  endfunction
endif

if has_key(g:plugs, 'defx-git')
  let g:defx_git#indicators = {
    \ 'Modified'  : '✹',
    \ 'Staged'    : '✚',
    \ 'Untracked' : '✭',
    \ 'Renamed'   : '➜',
    \ 'Unmerged'  : '═',
    \ 'Ignored'   : '☒',
    \ 'Deleted'   : '✖',
    \ 'Unknown'   : '?'
    \ }
  let g:defx_git#column_length = 0
  hi def link Defx_filename_directory NERDTreeDirSlash
  hi def link Defx_git_Modified Special
  hi def link Defx_git_Staged Function
  hi def link Defx_git_Renamed Title
  hi def link Defx_git_Unmerged Label
  hi def link Defx_git_Untracked Tag
  hi def link Defx_git_Ignored Comment
endif

if has_key(g:plugs, 'defx-icons')
  " Requires nerd-font, install at https://github.com/ryanoasis/nerd-fonts or
  " brew cask install font-hack-nerd-font
  " Then set non-ascii font to Driod sans mono for powerline in iTerm2

  " disbale syntax highlighting to prevent performence issue
  let g:defx_icons_enable_syntax_highlight = 1
endif

if has_key(g:plugs, 'coc.nvim')
  let $PATH .= ':'.my_cache_path.'/gopath/bin'

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
    return !col || getline('.')[col - 1] =~# '\s'
  endfunction

  let g:coc_snippet_next = '<tab>'
  " }}
endif
