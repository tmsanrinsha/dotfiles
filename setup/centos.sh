#!/usr/bin/env bash
set -e
sudo yum -y install ctags git zsh

# for pyenv
sudo yum -y install bzip2-devel openssl-devel readline-devel sqlite-devel zlib-devel

# for vim
sudo yum -y install gcc make ncurses-devel
sudo yum -y install perl-devel perl-ExtUtils-Embed
sudo yum -y install ruby-devel
sudo yum -y install python-devel
sudo yum -y install lua-devel

git clone --depth 1 https://github.com/vim/vim.git ~/src/github.com/vim/vim
cd ~/src/github.com/vim/vim/src
# make distclean || :
# rm auto/config.cache || :

# pyenvで設定しているとき
# [え？君せっかく Python のバージョン管理に pyenv 使ってるのに Vim の補完はシステムライブラリ参照してるの？ - Λlisue's blog](http://lambdalisue.hatenablog.com/entry/2014/05/21/065845)
py2version=$(python2 --version 2>&1 | awk '{print $2}')
py3version=$(python3 --version 2>&1 | awk '{print $2}')
LDFLAGS="-Wl,-rpath=${HOME}/.pyenv/versions/${py2version}/lib:${HOME}/.pyenv/versions/${py3version}/lib" ./configure \
  --enable-fail-if-missing \
  --enable-luainterp \
  --enable-perlinterp \
  --enable-pythoninterp=dynamic \
  --enable-python3interp=dynamic \
  --enable-rubyinterp=yes \
  --enable-multibyte \
  --enable-fontset \
  --with-features=huge \
  --disable-gui \
  --without-x

# pyenvなし
# ./configure \
# --with-features=huge \
# --enable-multibyte \
# --disable-gui \
# --without-x \
# --enable-rubyinterp \
# --enable-pythoninterp \
# --enable-perlinterp \
# --enable-luainterp

make
sudo make install

sudo yum -y boost-devel cmake cmake3 gcc-c++
