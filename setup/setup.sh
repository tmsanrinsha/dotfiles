#!/usr/bin/env bash

set -ex

# http://qiita.com/yudoufu/items/48cb6fb71e5b498b2532
git_dir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; cd ..; pwd)"

if [[ `uname` = CYGWIN* ]]; then
    # Windowsのメッセージの文字コードをcp932からutf-8に変更
    # なぜか英語になっちゃう
    cmd /c chcp 65001

    # cygwinのlnをmklinkで実行するスクリプトを実行できるようにPATHを通す
    export PATH=$gitdir/bin/cygwin:$PATH
fi

# リンクの作成
if [[ "`hostname`" = *ua.sakura.ne.jp ]]; then
    exclude=''
else
    exclude='.*\.local'
fi

# ディレクトリの作成
for dir in `find $git_dir -type d -name .git -prune -o -mindepth 1 -type d | sed -e "s|$git_dir/||"`
do
    test -d ~/$dir || mkdir ~/$dir
done

# シンボリックリンクを貼る
for file in `find $git_dir -type f ! -regex '.*README.*' ! -regex \'$exclude\' ! -regex '.*\.git.*' ! -regex '.*swp.*' | sed "s|$git_dir/||"`
do
    if [ -f ~/$file -a ! -L ~/$file ]; then # 実体ファイルがある場合はバックアップをとる
        mv ~/$file ~/${file}.bak
    fi
    if [ ! -f ~/$file ]; then
        ln -fsv $git_dir/$file ~/$file
    fi
done

# [ ! -f ~/.gitconfig ] && cp $gitdir/.gitconfig ~/.gitconfig

# http://betterthangrep.com/
# if [ ! -x ~/bin/ack ];then
#     curl http://betterthangrep.com/ack-standalone > ~/bin/ack
#     chmod a+x ~/bin/ack
# fi

[ ! -d ~/bin/pseudo ] && mkdir -p ~/bin/pseudo

if [ ! -x ~/bin/pseudo/git ];then
    # http://d.hatena.ne.jp/hnw/20120602
    # https://github.com/hnw/fakegit
    curl -L https://raw.github.com/hnw/fakegit/master/bin/fakegit > ~/bin/pseudo/git
    chmod a+x $HOME/bin/pseudo/git
fi

if [[ `uname` = CYGWIN* ]]; then
    [ ! -d ~/bin/cygwin ] && mkdir -p ~/bin/cygwin

    if [ ! -x ~/bin/cygwin/apt-cyg ]; then
        curl -LO https://raw.github.com/rcmdnk/apt-cyg/master/apt-cyg
        chmod a+x ~/bin/cygwin/apt-cyg
    fi

    alias apt-cyg='~/bin/cygwin/apt-cyg -m ftp://ftp.jaist.ac.jp/pub/cygwin/x86_64 -c /package'

    if ! which ssh 1>/dev/null 2>&1; then
        apt-cyg install openssh
    fi
    if ! which mercurial 1>/dev/null 2>&1; then
        apt-cyg install mercurial
    fi

    # cygwinでpageantを使う
    # http://sanrinsha.lolipop.jp/blog/2012/08/cygwin%E3%81%A7pageant%E3%82%92%E4%BD%BF%E3%81%86.html
    if [ ! -x /usr/bin/ssh-pageant ]; then
        cd /usr/src
        curl -L https://github.com/downloads/cuviper/ssh-pageant/ssh-pageant-1.1-release.tar.gz | tar  zxvf -
        cd ssh-pageant-1.1
        cp ssh-pageant.exe /usr/bin/
        cp ssh-pageant.1 /usr/share/man/man1/
    fi
fi

# zsh
if [ ! -d ~/git/z ]; then
    test -d ~/git || mkdir ~/git
    git clone git://github.com/rupa/z.git ~/git/z
    test -d ~/.zsh/plugin || mkdir -p ~/.zsh/plugin
    ln -s ~/git/z/z.sh ~/.zsh/plugin
    test -d ~/local/man/man1 || mkdir -p ~/local/man/man1
    ln -s ~/git/z/z.1 ~/local/man/man1
    test -d ~/.z || mkdir -p ~/.z
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
# cpanm --skip-installed App::Ack
