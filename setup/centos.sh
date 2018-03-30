#!/usr/bin/env bash
set -e
sudo yum -y install ctags git zsh

# for pyenv
sudo yum -y install bzip2-devel openssl-devel readline-devel sqlite-devel zlib-devel
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(command pyenv init -)"
py2version=$(pyenv install --list | grep '\s\+2[.0-9]\+$' | tail -1 | tr -d ' ')
py3version=$(pyenv install --list | grep '\s\+3[.0-9]\+$' | tail -1 | tr -d ' ')
CONFIGURE_OPTS="--enable-shared" pyenv install $py2version
CONFIGURE_OPTS="--enable-shared" pyenv install $py3version
pyenv global $py2version $py3version

# for vim
sudo yum -y install \
  gcc make ncurses-devel \
  perl-devel perl-ExtUtils-Embed \
  ruby-devel \
  python-devel \
  lua-devel

git clone --depth 1 https://github.com/vim/vim.git ~/src/github.com/vim/vim
cd ~/src/github.com/vim/vim/src
# make distclean || :
# rm auto/config.cache || :

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

make
sudo make install

pip3 install neovim
pip3 install -U --force-reinstall --no-binary :all: greenlet

sudo yum -y boost-devel cmake cmake3 gcc-c++
