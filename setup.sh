#!/bin/sh

PWD=`pwd`
ln -svn $PWD/.* $HOME
mkdir $HOME/bin
# 実行ファイル系はハードリンクにする。
# $HOME/binにパスが通っているとする
ln -vn $PWD/bin/* $HOME/bin

# http://betterthangrep.com/
curl http://betterthangrep.com/ack-standalone > ~/local/bin/ack && chmod 0755 !#:3
