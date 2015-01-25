#!/usr/bin/env bash
set -ex

##
# Usage:
# curl -kL https://raw.github.com/tmsanrinsha/dotfiles/master/setup/installer.sh | bash
# or
# wget --no-check-certificate -O -  https://raw.github.com/tmsanrinsha/dotfiles/master/setup/installer.sh | bash

SRC_ROOT="$HOME/git"
if [ ! -d $SRC_ROOT/tmsanrinsha ]; then
    mkdir -p $SRC_ROOT/tmsanrinsha
fi
if [ ! -d $SRC_ROOT/tmsanrinsha/dotfiles ]; then
    cd $SRC_ROOT/tmsanrinsha
    git clone git://github.com/tmsanrinsha/dotfiles.git
else
    cd $SRC_ROOT/tmsanrinsha/dotfiles
    git pull
fi
bash $SRC_ROOT/tmsanrinsha/dotfiles/setup/setup.sh
# if ! type ghq; then
#     test -d ~/bin || mkdir ~/bin
#     cd /tmp
#     url='https://github.com/motemen/ghq/releases/download/v0.4'
#     case `uname` in
#         Linux)
#             curl -fLO "${url}/ghq_linux_amd64.tar.gz"
#             gzip -dc ghq_linux_amd64.tar.gz | tar xf -
#             cp /tmp/ghq_linux_amd64/ghq ~/bin
#             export PATH=~/bin:$PATH
#             ;;
#         Darwin)
#             if ! type go; then
#                 brew install go
#             fi
#             export GOPATH=$HOME/.go
#             go get github.com/motemen/ghq
#             export PATH=$GOPATH/bin:$PATH
#             ;;
#         *)
#             echo "Don't match anything"
#             exit
#     esac
# fi
#
# SRC_ROOT="$HOME/git"
# git config --global --remove-section "ghq" || :
# git config --global "ghq.root" "$SRC_ROOT"
#
# ghq get https://github.com/tmsanrinsha/dotfiles
# bash $SRC_ROOT/github.com/tmsanrinsha/dotfiles/setup/setup.sh
