#!/usr/bin/env bash

sudo yum -y install ctags
sudo yum -y install git
sudo yum -y install zlib-devel

# for vim
sudo yum -y install gcc make ncurses-devel
sudo yum -y install perl-devel perl-ExtUtils-Embed
sudo yum -y install ruby-devel
sudo yum -y install python-devel
sudo yum -y install lua-devel

git clone --depth 1 https://github.com/vim/vim.git ~/src/github.com/vim/vim
cd ~/src/github.com/vim/vim/src

./configure \
--with-features=huge \
--enable-multibyte \
--disable-gui \
--without-x \
--enable-rubyinterp \
--enable-pythoninterp \
--enable-perlinterp \
--enable-luainterp

make
sudo make install
