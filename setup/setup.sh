#!/usr/bin/env bash

set -ex

if [[ `uname` = CYGWIN* ]]; then
    [ ! -d ~/bin/cygwin ] && mkdir -p ~/bin/cygwin
    if [ ! -x ~/bin/cygwin/ln ]; then
        curl -L https://raw.github.com/tmsanrinsha/dotfiles/master/bin/cygwin/ln > ~/bin/cygwin/ln
        chmod a+x ~/bin/cygwin/ln
        alias ln="~/bin/cygwin/ln"
    fi
    if [ ! -x ~/bin/cygwin/apt-cyg ]; then
        curl -L http://apt-cyg.googlecode.com/svn/trunk/apt-cyg > ~/bin/cygwin/apt-cyg
        chmod a+x ~/bin/cygwin/apt-cyg
    fi
    # cmdのコマンドを打った時の文字コードをcp932からutf-8に変更
    # なぜか英語になっちゃう
    cmd /c chcp 65001
fi

# リンクの作成
gitdir=`pwd | sed 's|/setup$||'`
for file in `find .. -maxdepth 1 -type f ! -regex '.*README.*' ! -regex '.*.git.*' | sed 's|../||'`
do
    [ ! -f ~/$file ] && ln -sv $gitdir/$file ~/$file
done
[ ! -f ~/.gitconfig ] && cp $gitdir/.gitconfig ~/.gitconfig
[ ! -d ~/bin ] && ln -sv $gitdir/bin ~/bin

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

# vim
if [ ! -d ~/.vim/bundle/neobundle.vim ] && which git 1>/dev/null 2>&1;then
    mkdir -p ~/.vim/bundle
    git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
fi

# cpanm
if ! which cpanm 1>/dev/null 2>&1;then
    source cpanm.sh
fi
cpanm --skip-installed MIME::Base64
