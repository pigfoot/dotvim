" For pathogen.vim: auto load all plugins in .vim/bundle, and it should turn
" off filetype otherwise ftdetect wouldn't work.
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" General Settings
syntax on               " syntax highlight

" screen with --enable-colors256 (Gentoo does this by default!)
if ($TERM == 'screen' || $TERM == 'xterm')
    set t_Co=256
endif

if &t_Co >= 256
    try
        colorscheme jellybeans
    catch
        colorscheme desert
    endtry
else
    colorscheme desert
endif

set hlsearch            " search highlighting
set nocompatible        " not compatible with the old-fashion vi mode
set bs=2                " allow backspacing over everything in insert mode
set history=50          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set autoread            " auto read when file is changed from outside
set autoindent          " auto indentation
set incsearch           " incremental search
set nobackup            " no *~ backup files
set copyindent          " copy the previous indentation on autoindenting
set ignorecase          " ignore case when searching
set smartcase           " ignore case if search pattern is all lowercase,case-sensitive otherwise
set smarttab            " insert tabs on the start of a line according to context
set nowrap

filetype on             " Enable filetype detection
filetype indent on      " Enable filetype-specific indenting
filetype plugin on      " Enable filetype-specific plugins

" auto reload vimrc when editing it
autocmd! bufwritepost .vimrc source ~/.vimrc

" set listchars=tab:\|\ ,trail:_,eol:$,extends:>,precedes:<

" C/C++ specific settings
autocmd FileType c,cpp,cc set cindent comments=sr:/*,mb:*,el:*/,:// cino=>s,e0,n0,f0,{0,}0,^-1s,:0,=s,g0,h1s,p2,t0,+2,(2,)20,*30

"Restore cursor to file position in previous editing session
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
    set ffs=unix,dos,mac    "set fileformats=unix,dos,mac
    set ff=unix             "set fileformat=unix

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
    set et              " set expandtab; replace <TAB> with spaces
    set ts=4            " set tabstop=4
    set sts=4           " set softtabstop=4
    set sw=4            " set shiftwidth=4

    au FileType Makefile set noexpandtab
"}

" status line {
    set ls=2            " set laststatus=2; Always show status line
    if has('statusline')

        " Status line detail:  /usr/share/vim/vim7/doc/options.txt
        "
        " %f                                                   file path
        " %y                                                   file type between braces (if defined)
        " %([%R%M]%)                                           read-only, modified and modifiable flags between braces
        " %{'!'[&ff=='default_file_format']}                   shows a '!' if the file format is not the platform default
        " %{'$'[!&list]}                                       shows a '*' if in list mode
        " %{'~'[&pm=='']}                                      shows a '~' if in patchmode
        " (%{synIDattr(synID(line('.'),col('.'),0),'name')})   only for debug: display the current syntax item name
        " %=                                                   right-align following items
        " #%n                                                  buffer number
        " %l/%L,%c%V                                           line number, total number of lines, and column number

        " vimrc            \   [unix/VIM/utf-8]          sojia:~/.vim\         90,8       86%/104
        function SetStatusLineStyle_vgod()
            set statusline=\ %{HasPaste()}%<%-15.25(%f%)%m%r%h\ %w\
            set statusline+=\ \ \ [%{&ff}/%Y/%{&encoding}]
            set statusline+=\ \ \ %<%20.30(%{hostname()}:%{CurDir()}%)/
            set statusline+=%=%-10.(%l,%c%V%)\ %p%%/%L
        endfunction

        function! CurDir()
            let curdir = substitute(getcwd(), $HOME, "~", "")
            return curdir
        endfunction

        function! HasPaste()
            if &paste
                return '[PASTE]'
            else
                return ''
            endif
        endfunction

        " vimrc [vim][vim,utf-8,unix]                                       #1 62/115,1 [22%]
        function SetStatusLineStyle()
            if &stl == '' || &stl =~ 'synID'
                let &stl="%f %y%([%R%M]%)%{'!'[&ff=='".&ff."']}%{'$'[!&list]}%{'~'[&pm=='']}\[%{strlen(&ft)?&ft:'none'},%{&encoding},%{&fileformat}]%=#%n %l/%L,%c [%P]"
            else
                let &stl="%f %y%([%R%M]%)%{'!'[&ff=='".&ff."']}%{'$'[!&list]} (%{synIDattr(synID(line('.'),col('.'),0),'name')})%=#%n %l/%L,%c %p%"
            endif
        endfunc

        " Switch between the normal and vim-debug modes in the status line
        "nmap _ds :call SetStatusLineStyle()<CR>
        "call SetStatusLineStyle()
        call SetStatusLineStyle_vgod()

    endif
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
function! RemoveTrailingSpace()
    "if $VIM_HATE_SPACE_ERRORS != '0' && (&filetype == 'c' || &filetype == 'cpp' || &filetype == 'vim')
    if $VIM_HATE_SPACE_ERRORS != '0'
        normal m`
        silent! :%s/\s\+$//e
        normal ``
    endif
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
"let mapleader=","
"let g:mapleader=","

"Trim all trailing spaces by \r
map <leader>r :call RemoveTrailingSpace()<CR>

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
"Set tags search path
set tags+=~/.vim/tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags,../../../../../tags

" --- Command-T
let g:CommandTMaxHeight = 15

" --- SuperTab
let g:SuperTabDefaultCompletionType = "context"

" --- Omni completion.
set completeopt-=preview

" --- gitgutter: let SignColumn background is the same as what jellybeans provides
highlight SignColumn ctermbg=777

" --- fugitive
if has("autocmd")
    autocmd User fugitive if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' | nnoremap <buffer> .. :edit %:h<CR> | endif
    autocmd BufReadPost fugitive://* set bufhidden=delete
endif
