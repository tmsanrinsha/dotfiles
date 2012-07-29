#!/bin/sh

# dotfilesにシンボリックリンクを貼る
find `pwd` -type f -regex ".*/\..*" ! -regex ".*/\.git.*" | xargs -I{} ln -svn {} $HOME

mkdir $HOME/bin
# 実行ファイル系はハードリンクにする。
# $HOME/binにパスが通っているとする
PWD=`pwd`
ln -vn $PWD/bin/* $HOME/bin

# http://betterthangrep.com/
curl http://betterthangrep.com/ack-standalone > ~/bin/ack && chmod 0755 ~/bin/ack
