#!/usr/bin/env bash

sudo yum -y install gcc make ncurses-devel
sudo yum -y install perl-devel perl-ExtUtils-Embed
sudo yum -y install ruby-devel
sudo yum -y install python-devel

git clone https://github.com/vim/vim.git ~/vim
cd ~/vim/src

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

sudo yum -y install ctags
