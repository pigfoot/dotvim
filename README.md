pigfoot's vimrc
============
Author: Chih-Chia Chen <pigfoot@gmail.com>

Fork me on GITHUB  https://github.com/pigfoot/dotvim

HOW TO INSTALL
--------------

## Check out from github
```
$ git clone https://github.com/pigfoot/dotvim.git ~/.vim
$ ln -s ~/.vim/vimrc ~/.vimrc
$ mkdir -p ~/.config/nvim
$ cat <<EOF > ~/.config/nvim/init.vim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vim/vimrc
EOF
```

## Setting

### vim-go (Optional)
Here is following action if you would like to use `fatih/vim-go`.
Related binaries, like gocode, godef, and goimports, would be installed in first time.
Or you can use `:GoInstallBinaries` to install it manually.

Since `gofumports` (https://github.com/mvdan/gofumpt) is better than `godef`/`goimports`
As a result please use the following intructions to install `gofumports`

```
$ _TMP_GO=$(mktemp -d); \
  go mod init tmp; \
  go get mvdan.cc/gofumpt/gofumports; \
  cp -av ${GOPATH}/bin/gofumports ~/.cache/vim/gopath/bin; \
  cd - > /dev/null 2>&1; \
  rm -rf ${_TMP_GO}
```

## Install all plugins

You can launch vim and run:
```
: so $MYVIMRC
: PlugInstall
```

## Reset entire environment

```
$ rm -rf ~/.cache/vim; \
  rm -rf ~/.cache/nvim; \
  rm -rf ~/.vim/autoload; \
  rm -rf ~/.local/share/nvim/site/autoload; \
  rm -rf ~/.config/coc
```

# PLUGINS
-------
* [colors-solarized](https://github.com/altercation/vim-colors-solarized): precision colorscheme for the vim text editor

* [ultisnips](https://github.com/SirVer/ultisnips): The ultimate snippet solution for python enabled Vim

* [vim-go](https://github.com/fatih/vim-go.git): Go development plugin for Vim

* [gitgutter](https://github.com/airblade/vim-gitgutter): A Vim plugin which shows a git diff in the gutter
