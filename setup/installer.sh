#!/usr/bin/env bash
set -ex

##
# Usage:
# bash <(curl -kL https://raw.github.com/tmsanrinsha/dotfiles/master/setup/installer.sh) [-b]
# or
# bash <(wget --no-check-certificate -O -  https://raw.github.com/tmsanrinsha/dotfiles/master/setup/installer.sh) [-b]
# Option:
#  -b: homebrewの更新を行う

export SRC_ROOT="$HOME/src"
if [ ! -d $SRC_ROOT/github.com/tmsanrinsha/dotfiles/.git ]; then
    mkdir -p $SRC_ROOT/github.com/tmsanrinsha
    cd $SRC_ROOT/github.com/tmsanrinsha
    git clone https://github.com/tmsanrinsha/dotfiles.git
else
    cd $SRC_ROOT/github.com/tmsanrinsha/dotfiles
    git pull
fi
bash $SRC_ROOT/github.com/tmsanrinsha/dotfiles/setup/setup.sh $1

# if ! which ghinst; then
#     test -d ~/bin || mkdir ~/bin
#     git clone https://github.com/tmsanrinsha/ghinst.git $SRC_ROOT/github.com/tmsanrinsha
#     chmod a+x ~/bin/ghinst
# fi
# PATH=${HOME}/bin:$PATH

# SRC_ROOT="$HOME/src"
# git config --global --remove-section "ghq" || :
# git config --global "ghq.root" "$SRC_ROOT"
#
# ghq get -u tmsanrinsha/dotfiles
# bash $SRC_ROOT/github.com/tmsanrinsha/dotfiles/setup/setup.sh $1
