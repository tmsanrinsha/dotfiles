#!/usr/bin/env bash

# dotfilesにリンクを貼る
find `pwd` -type d -name '.git' -prune -o -type f -regex ".*/\..*" -print | xargs -I{} ln -v {} $HOME

[ ! -d ~/bin ] && mkdir ~/bin
# 実行ファイルにリンクを貼る
find `pwd`/bin -maxdepth 1 -type f | xargs -I{} ln -v {} $HOME/bin

# http://betterthangrep.com/
if [ ! -x ~/bin/ack ];then
    curl http://betterthangrep.com/ack-standalone > ~/bin/ack
    chmod a+x ~/bin/ack
fi

[ ! -d ~/bin/pseudo ] && mkdir ~/bin/pseudo

# http://d.hatena.ne.jp/hnw/20120602
# https://github.com/hnw/fakegit
if [ ! -x ~/bin/pseudo/git ];then
    curl -L https://raw.github.com/hnw/fakegit/master/bin/fakegit > ~/bin/pseudo/git
    chmod a+x $HOME/bin/pseudo/git
fi

if [ ! -d ~/.vim/bundle/neobundle.vim ] && which git 1>/dev/null 2>&1;then
    mkdir -p ~/.vim/bundle
    git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
fi

if [[ `uname` = CYGWIN* ]]; then
    [ ! -d ~/bin/cygwin ] && mkdir -p ~/bin/cygwin
    if [ ! -x ~/bin/cygwin/ln ]; then
        curl -L https://raw.github.com/tmsanrinsha/dotfiles/master/bin/cygwin/ln > ~/bin/cygwin/ln
        chmod a+x ~/bin/cygwin/ln
    fi
fi

. ~/.bash_profile
