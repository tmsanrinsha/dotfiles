#!/bin/sh

if [[ `uname` = CYGWIN* ]]; then
    [ ! -d ~/bin/cygwin ] && mkdir -p ~/bin/cygwin
    if [ ! -x ~/bin/cygwin/ln ]; then
        curl -L https://raw.github.com/tmsanrinsha/dotfiles/master/bin/cygwin/ln > ~/bin/cygwin/ln
        chmod a+x ~/bin/cygwin/ln
        ln=~/bin/cygwin/ln
    fi
else
    ln=`which ln`
fi

[ ! -d ~/bin ] && mkdir ~/bin
# 実行ファイル系はハードリンクにする。
# $HOME/binにパスが通っているとする
find `pwd`/bin -maxdepth 1 -type f | xargs -I{} $ln -v {} $HOME/bin
#$ln -v $PWD/bin/* $HOME/bin

# dotfilesにシンボリックリンクを貼る
find `pwd` -type f -regex ".*/\..*" ! -regex ".*/\.git.*" | xargs -I{} $ln -sv {} $HOME


# http://betterthangrep.com/
if [ ! -f ~/bin/ack ];then
    curl http://betterthangrep.com/ack-standalone > ~/bin/ack
    chmod a+x ~/bin/ack
fi

[ ! -d ~/bin/pseudo ] && mkdir ~/bin/pseudo

# http://d.hatena.ne.jp/hnw/20120602
# https://github.com/hnw/fakegit
if [ ! -f ~/bin/pseudo/git ];then
    curl -L https://raw.github.com/hnw/fakegit/master/bin/fakegit > ~/bin/pseudo/git
    chmod a+x $HOME/bin/pseudo/git
fi

. ~/.bash_profile
