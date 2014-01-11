#!/usr/bin/env bash
set -ex

# curl -L https://raw.github.com/tmsanrinsha/dotfiles/master/setup/installer.sh | bash

if ! test -d $HOME/.homesick/repos; then
    mkdir -p $HOME/.homesick/repos
    cd $HOME/.homesick/repos
    git clone git://github.com/andsens/homeshick.git
fi
source $HOME/.homesick/repos/homeshick/homeshick.sh

if ! test -d $HOME/.homesick/repos/dotfiles; then
    homeshick clone git://github.com/tmsanrinsha/dotfiles
fi

git_dir=$HOME/.homesick/repos/dotfiles

if [[ `uname` = CYGWIN* ]]; then
    # Windowsのメッセージの文字コードをcp932からutf-8に変更
    # なぜか英語になっちゃう
    cmd /c chcp 65001

    # cygwinのlnをmklinkで実行するスクリプトを実行できるようにPATHを通す
    # ln=$git_dir/script/cygwin/ln
    export PATH=$git_dir/.homesick/repos/dotfiles/script/cygwin/ln:$PATH
fi

homeshick link

$git_dir/setup/setup.sh

