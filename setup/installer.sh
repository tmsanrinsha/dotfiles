#!/usr/bin/env bash
set -ex

##
# Usage:
# bash <(curl -kL https://raw.github.com/tmsanrinsha/dotfiles/master/setup/installer.sh) [-bv]
# or
# bash <(wget --no-check-certificate -O -  https://raw.github.com/tmsanrinsha/dotfiles/master/setup/installer.sh) [-bv]
# Option:
#  -b: homebrewの更新を行う
#  -v: neoinstallする

if [[ ! -x ~/bin/ghinst ]]; then
    curl -L 'https://raw.githubusercontent.com/tmsanrinsha/ghinst/master/ghinst' > ~/bin/ghinst
    chmod a+x ~/bin/ghinst
fi
PATH=${HOME}/bin:$PATH

ghinst motemen/ghq

# if [ ! -d $SRC_ROOT/github.com/tmsanrinsha ]; then
#     mkdir -p $SRC_ROOT/tmsanrinsha
# fi
# if [ ! -d $SRC_ROOT/tmsanrinsha/dotfiles ]; then
#     cd $SRC_ROOT/tmsanrinsha
#     git clone git://github.com/tmsanrinsha/dotfiles.git
# else
#     cd $SRC_ROOT/tmsanrinsha/dotfiles
#     git pull
# fi

SRC_ROOT="$HOME/src"
git config --global --remove-section "ghq" || :
git config --global "ghq.root" "$SRC_ROOT"

ghq get -u tmsanrinsha/dotfiles
bash $SRC_ROOT/github.com/tmsanrinsha/dotfiles/setup/setup.sh $1
