pigfoot's vimrc
============
Author: Chih-Chia Chen <pigfoot@gmail.com>

Fork me on GITHUB  https://github.com/pigfoot/dotvim

HOW TO INSTALL
--------------

1. Check out from github
    $ git clone https://github.com/pigfoot/dotvim.git ~/.vim
    $ ln -s ~/.vim/vimrc ~/.vimrc

2. (Optional) Disable vim-go by comment out "Plugin 'fatih/vim-go'" in ~/.vimrc
   Here is following action if you would like to use fatih/vim-go
   Or you can install manually by install gocode, godef, and goimports

   3.1
     install related tools by launching vim and run :GoInstallBinaries
     :GoInstallBinaries

   3.2
     install gofumports (https://github.com/mvdan/gofumpt)
     $ cd $(mktemp -d); go mod init tmp; go get mvdan.cc/gofumpt

3. Install all plugins: Launch vim and run :PlugInstall

4. Reset entire environment
   $ rm -rf ~/.cache/vim
   $ rm -rf ~/.cache/nvim
   $ rm -rf ~/.vim/autoload
   $ rm -rf ~/.local/share/nvim/site/autoload
   $ sudo rm -rf ~/.config/coc

PLUGINS
-------
* [colors-solarized](https://github.com/altercation/vim-colors-solarized): precision colorscheme for the vim text editor

* [ultisnips](https://github.com/SirVer/ultisnips): The ultimate snippet solution for python enabled Vim

* [vim-go](https://github.com/fatih/vim-go.git): Go development plugin for Vim

* [gitgutter](https://github.com/airblade/vim-gitgutter): A Vim plugin which shows a git diff in the gutter
