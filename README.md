pigfoot's vimrc
============
Author: Chih-Chia Chen <pigfoot@gmail.com>

Fork me on GITHUB  https://github.com/pigfoot/dotvim

HOW TO INSTALL
--------------

1. Check out from github
    $ git clone https://github.com/pigfoot/dotvim.git ~/.vim
    $ ln -s ~/.vim/vimrc ~/.vimrc

2. (Optional) DisableYouCompleteMe by commenting out "Plug 'Valloric/YouCompleteMe'" in ~/.vimrc and goto next step

  2.1 Install YouCompleteMe
    $ cd ~/.vim/plugged/YouCompleteMe/

    # Let ycmd to adopt stamblerre/gocde
    # https://magodo.github.io/vim-go/
    $ cd third_party/ycmd/third_party/go/src/github.com/ \
      && mkdir -p stamblerre && cd stamblerre \
      && git clone git@github.com:stamblerre/gocode.git \
      && export GOPATH=$HOME/.vim/plugged/YouCompleteMe/third_party/ycmd/third_party/go \
      && cd gocode \
      && go get golang.org/x/tools/go/packages \
      && cd ../../../../../../../../ \
      && sed -ri 's#mdempsky#stamblerre#' third_party/ycmd/build.py \
      && sed -ri 's#mdempsky#stamblerre#' third_party/ycmd/ycmd/completers/go/go_completer.py 

    # Compiling YCM with semantic support for C-family languages (C/C++/ObjC)
    $ ./install.py --clang-completer (prebuilt libclang)

    # Append system clang path (system libclang)
    $ LD_LIBRARY_PATH=$(equery f sys-devel/clang | sed -rn '/libclang.so$/s#/libclang.so##p') ./install.py --clang-completer --system-libclang

    # Or compiling YCM without semantic support for C-family languages
    $ ./install.py

    # Or additionally compiling Go semantic completion engine
    $ ./install.py --clang-completer --gocode-completer

    # My setting
    $ (Linux) LD_LIBRARY_PATH=$(equery f sys-devel/clang | sed -rn '/libclang.so$/s#/libclang.so##p') ./install.py --clang-completer --system-libclang --gocode-completer
    $ (MacOS) ./install.py --clang-completer --system-libclang --gocode-completer

    # check library
    $ (Linux) ldd ~/.vim/plugged/YouCompleteMe/third_party/ycmd/ycm_core.so
    $ (MacOS) otool -L ~/.vim/plugged/YouCompleteMe/third_party/ycmd/ycm_core.so

3. (Optional) Disable vim-go by comment out "Plugin 'fatih/vim-go'" in ~/.vimrc
   Here is following action if you would like to use fatih/vim-go
   Or you can install manually by install gocode, godef, and goimports

   3.1 (Easy)
     install related tools by launching vim and run :GoInstallBinaries
     :GoPath $HOME/.vim/bundle/gopath
     :GoInstallBinaries

   3.2 (Expert)
     $ sudo emerge -av dev-go/gocode \
                       dev-util/gometalinter \
                       dev-go/go-tools \
                       dev-util/golint \
                       dev-util/godef \
                       dev-util/errcheck \
                       dev-util/gotags \
                       dev-go/asmfmt \
                       app-misc/motion \
                       app-misc/gogetdoc \
                       app-misc/impl

5. Install all plugins: Launch vim and run :PlugInstall


PLUGINS
-------
* [colors-solarized](https://github.com/altercation/vim-colors-solarized): precision colorscheme for the vim text editor

* [jellybeans](https://github.com/nanotech/jellybeans.vim): A colorful, dark color scheme for Vim

* [airline](https://github.com/bling/vim-airline): lean & mean statusline for vim that's light as air

* [YouCompleteMe](https://github.com/Valloric/YouCompleteMe): A code-completion engine for Vim

* [ultisnips](https://github.com/SirVer/ultisnips): The ultimate snippet solution for python enabled Vim

* [vim-go](https://github.com/fatih/vim-go.git): Go development plugin for Vim

* [ctrlp.vim](https://github.com/kien/ctrlp.vim): Fuzzy file, buffer, mru, tag, etc finder

* [Nerd Tree](https://github.com/scrooloose/nerdtree): A tree explorer plugin for navigating the filesystem.
  Useful commands:
  `:Bookmark [name]` - bookmark any directory as name
  `:NERDTree [name]` - open the bookmark [name] in Nerd Tree

* [gitgutter](https://github.com/airblade/vim-gitgutter): A Vim plugin which shows a git diff in the gutter

* [fugitive](https://github.com/tpope/vim-fugitive): a Git wrapper so awesome

* [vim-vue](https://github.com/posva/vim-vue): Syntax Highlight for Vue.js components
