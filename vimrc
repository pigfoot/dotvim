"---------------------------------------------------------------------------
" Vundle Settings
"---------------------------------------------------------------------------
set nocompatible            " not compatible with the old-fashion vi mode
filetype off                " required!

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required!
Bundle 'gmarik/Vundle.vim'

" Theme Bundles
Plugin 'altercation/vim-colors-solarized'
Plugin 'nanotech/jellybeans.vim'

" UI Bundles
Plugin 'bling/vim-airline'

" Programming efficiency Bundles
Plugin 'Valloric/YouCompleteMe'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'fatih/vim-go'
"Plugin 'nsf/gocode', {'rtp': 'vim/'}

" file management Bundles
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'

" CSV Bundles
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" All of your Plugins must be added before the following line
call vundle#end()           " required
filetype plugin indent on   " required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"---------------------------------------------------------------------------
" General Settings
"---------------------------------------------------------------------------
syntax on                   " syntax highlight

" screen with --enable-colors256 (Gentoo does this by default!)
if ($TERM == 'screen' || $TERM == 'xterm' || $TERM == 'xterm-256color')
    set t_Co=256
endif

if &t_Co >= 256
    try
        set background=dark
        let g:solarized_termcolors=256
        colorscheme solarized
    catch
        colorscheme desert
    endtry
else
    try
        set background=dark
        let g:solarized_termcolors=256
        colorscheme solarized
    catch
        colorscheme desert
    endtry
endif

set hlsearch                " search highlighting
set nocompatible            " not compatible with the old-fashion vi mode
set bs=2                    " allow backspacing over everything in insert mode
set history=50              " keep 50 lines of command line history
set ruler                   " show the cursor position all the time
set autoread                " auto read when file is changed from outside
set autoindent              " auto indentation
set incsearch               " incremental search
set nobackup                " no *~ backup files
set copyindent              " copy the previous indentation on autoindenting
set ignorecase              " ignore case when searching
set smartcase               " ignore case if search pattern is all lowercase,case-sensitive otherwise
set smarttab                " insert tabs on the start of a line according to context
set nowrap

" auto reload vimrc when editing it
autocmd! bufwritepost .vimrc source ~/.vimrc

" set listchars=tab:\|\ ,trail:_,eol:$,extends:>,precedes:<

" C/C++ specific settings
autocmd FileType c,cpp,cc set cindent comments=sr:/*,mb:*,el:*/,:// cino=>s,e0,n0,f0,{0,}0,^-1s,:0,=s,g0,h1s,p2,t0,+2,(2,)20,*30

" Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm'\"")|else|exe "norm $"|endif|endif

"---------------------------------------------------------------------------
" ENCODING SETTINGS
"---------------------------------------------------------------------------
" Encodings: {{{
if has("multi_byte")
    set encoding=utf-8
    set termencoding=utf-8
    set fileencoding=utf-8
    set fileencodings=utf-8,big5,gbk,ucs-bom,latin1,default
    set ffs=unix,dos,mac    " set fileformats=unix,dos,mac
    set ff=unix             " set fileformat=unix

    fun! ViewUTF8()
        set encoding=utf-8
        set termencoding=big5
    endfun

    fun! UTF8()
        set encoding=utf-8
        set termencoding=big5
        set fileencoding=utf-8
        set fileencodings=utf-8,big5,gbk,ucs-bom,latin1,default
    endfun

    fun! Big5()
        set encoding=big5
        set fileencoding=big5
    endfun
else
    echoerr "Sorry, this version of (g)vim was not compiled with multi_byte"
endif

" TAB setting {
    set et                  " set expandtab; replace <TAB> with spaces
    set ts=4                " set tabstop=4
    set sts=4               " set softtabstop=4
    set sw=4                " set shiftwidth=4

    au FileType Makefile set noexpandtab
"}

"---------------------------------------------------------------------------
"" Tip #382: Search for <cword> and replace with input() in all open buffers
"---------------------------------------------------------------------------
fun! Replace()
    let s:word = input("Replace " . expand('<cword>') . " with:")
    :exe 'bufdo! %s/\<' . expand('<cword>') . '\>/' . s:word . '/ge'
    :unlet! s:word
endfun

"---------------------------------------------------------------------------
" Trim trailing spaces
"---------------------------------------------------------------------------
function! StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

"---------------------------------------------------------------------------
"" PROGRAMMING SHORTCUTS
"---------------------------------------------------------------------------
fun! IncludeGuard()
   let basename = substitute(bufname(""), '.*/', '', '')
   let guard = '_' . substitute(toupper(basename), '\.', '_', "H") . '_'
   call append(0, "#ifndef " . guard)
   call append(1, "#define " . guard)
   call append(line("$"), "#endif /* " . guard . " */")
endfun

"---------------------------------------------------------------------------
" USEFUL SHORTCUTS
"---------------------------------------------------------------------------
" set leader from default \\ to ,
let mapleader = ","
let g:mapleader = ","

"Trim all trailing spaces by \r
map <leader>r :call StripTrailingWhitespaces()<CR>

"replace the current word in all opened buffers by \R
map <leader>R :call Replace()<CR>

"Use NerdTree
map <leader>n :NERDTree<CR>

"Use IncludeGuard() by \i
map <leader>i :call IncludeGuard()<CR>

"Use ctags by F12
map <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

"Increment/Decrement number by F10/F11 (conflict with screen's C-a)
map <F10> <C-a>
map <F11> <C-x>

"---------------------------------------------------------------------------
"" PLUGIN SETTINGS
"---------------------------------------------------------------------------

" Handle all issues between YCM and UltiSnips
let g:UltiSnipsExpandTrigger        = "<tab>"
let g:UltiSnipsJumpForwardTrigger   = "<tab>"
function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
               return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction
au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:syntastic_always_populate_loc_list = 1

"Set tags search path
"set tags+=~/.vim/tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags,../../../../../tags

" --- Omni completion.
set completeopt-=preview

" --- gitgutter: let SignColumn background is the same as what jellybeans provides
let g:gitgutter_highlight_lines = 1
highlight SignColumn ctermbg=234 guibg=#002b36

" --- fugitive
if has("autocmd")
    autocmd User fugitive if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' | nnoremap <buffer> .. :edit %:h<CR> | endif
    autocmd BufReadPost fugitive://* set bufhidden=delete
endif

" --- airline
set laststatus=2
let g:airline_powerline_fonts = 1

" --- CtrlP
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }

" --- vim-go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
