#!/bin/sh
set -x
# dotfilesにシンボリックリンクを貼る
find `pwd` -type f -regex ".*/\..*" ! -regex ".*/\.git.*" | xargs -I{} ln -svn {} $HOME

mkdir $HOME/bin
# 実行ファイル系はハードリンクにする。
# $HOME/binにパスが通っているとする
PWD=`pwd`
ln -vn $PWD/bin/* $HOME/bin

# http://betterthangrep.com/
if [ ! -f ~/bin/ack ];then
    curl http://betterthangrep.com/ack-standalone > ~/bin/ack && chmod 0755 ~/bin/ack
fi

[ ! -d ~/bin/pseudo ] && mkdir ~/bin/pseudo

# http://d.hatena.ne.jp/hnw/20120602
# https://github.com/hnw/fakegit
if [ ! -f ~/bin/pseudo/git ];then
    curl -L https://raw.github.com/hnw/fakegit/master/bin/fakegit > $HOME/bin/pseudo/git
    chmod a+x $HOME/bin/pseudo/git
fi
