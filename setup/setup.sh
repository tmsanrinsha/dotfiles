#!/usr/bin/env bash

set -ex

function command_exists {
  # コマンドの存在チェックはwhichよりhashの方が良いかも→いやtypeが最強
  # http://qiita.com/kawaz/items/1b61ee2dd4d1acc7cc94
  hash "$1" 2>/dev/null ;
}

# http://qiita.com/yudoufu/items/48cb6fb71e5b498b2532
git_dir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; cd ../; pwd)"

if [[ `uname` = CYGWIN* ]]; then
    # Windowsのメッセージの文字コードをcp932からutf-8に変更
    # なぜか英語になっちゃう
    cmd /c chcp 65001

    # cygwinのlnをmklinkで実行するスクリプトを実行できるようにPATHを通す
    ln=$git_dir/script/cygwin/ln
    # export PATH=$git_dir/script/cygwin:$PATH
    # echo  $PATH
else
    ln=ln
fi

# リンクの作成
if [[ "`hostname`" = *ua.sakura.ne.jp ]]; then
    exclude=''
else
    exclude='.*\.local'
fi

# ディレクトリの作成
for dir in `find $git_dir -mindepth 1 -type d ! -regex '.*\.git.*' ! -regex '.*setup.*' ! -regex '.*template.*' | sed -e "s|$git_dir/||"`
do
    test -d ~/$dir || mkdir ~/$dir
done

# シンボリックリンクを貼る
for file in `find $git_dir -type f ! -regex '.*README.*' ! -regex \'$exclude\' ! -regex '.*\.git.*' ! -regex '.*setup.*' ! -regex '.*template.*' ! -regex '.*swp.*' | sed "s|$git_dir/||"`
do
    # 実体ファイルがある場合はバックアップをとる
    if [ -f ~/$file -a ! -L ~/$file ]; then
        mv ~/$file ~/${file}.bak
    fi
    # シンボリックリンクは削除
    if [ -L ~/$file ]; then
        rm ~/$file
    fi
    $ln -sv $git_dir/$file ~/$file
done

# [ ! -f ~/.gitconfig ] && cp $gitdir/.gitconfig ~/.gitconfig

# http://betterthangrep.com/
# if [ ! -x ~/bin/ack ];then
#     curl http://betterthangrep.com/ack-standalone > ~/bin/ack
#     chmod a+x ~/bin/ack
# fi

# [ ! -d ~/script/pseudo ] && mkdir -p ~/script/pseudo
#
# if [ ! -x ~/script/pseudo/git ];then
#     # http://d.hatena.ne.jp/hnw/20120602
#     # https://github.com/hnw/fakegit
#     curl -L https://raw.github.com/hnw/fakegit/master/bin/fakegit > ~/script/pseudo/git
#     chmod a+x $HOME/script/pseudo/git
# fi

if [[ `uname` = CYGWIN* ]]; then
    [ ! -d ~/script/cygwin ] && mkdir -p ~/script/cygwin

    if [ ! -x ~/script/cygwin/apt-cyg ]; then
        curl https://raw.github.com/rcmdnk/apt-cyg/master/apt-cyg > ~/script/cygwin/apt-cyg
        chmod a+x ~/script/cygwin/apt-cyg
    fi

    apt_cyg="$HOME/script/cygwin/apt-cyg -m ftp://ftp.jaist.ac.jp/pub/cygwin/x86_64 -c /package"

    if ! command_exists ssh; then
        $apt_cyg install openssh
    fi
    if ! command_exists mercurial; then
        $apt_cyg install mercurial
    fi

    # cygwinでpageantを使う
    # http://sanrinsha.lolipop.jp/blog/2012/08/cygwin%E3%81%A7pageant%E3%82%92%E4%BD%BF%E3%81%86.html
    if [ ! -x /usr/bin/ssh-pageant ]; then
        pushd .
        cd /usr/src
        curl -L https://github.com/downloads/cuviper/ssh-pageant/ssh-pageant-1.1-release.tar.gz | tar  zxvf -
        cd ssh-pageant-1.1
        cp ssh-pageant.exe /usr/bin/
        cp ssh-pageant.1 /usr/share/man/man1/
        popd
    fi
elif [[ `uname` = Darwin ]]; then
    ln -s ~/_gvimrc ~/.gvimrc
    if which brew >/dev/null 2>&1; then
        if ! which zsh >/dev/null 2>&1; then
            brew install zsh
        fi
        if ! which python >/dev/null 2>&1; then
            brew install python
        fi
        if ! which mercurial >/dev/null 2>&1; then
            brew install mercurial
        fi
    fi
fi

# zsh
# if [ ! -d ~/git/z ]; then
#     test -d ~/git || mkdir ~/git
#     git clone git://github.com/rupa/z.git ~/git/z
#     test -d ~/.zsh/plugin || mkdir -p ~/.zsh/plugin
#     ln -s ~/git/z/z.sh ~/.zsh/plugin
#     test -d ~/local/man/man1 || mkdir -p ~/local/man/man1
#     ln -s ~/git/z/z.1 ~/local/man/man1
#     test -d ~/.z || mkdir -p ~/.z
# fi

# vim
if [ ! -d ~/.vim/bundle/neobundle.vim ] && which git 1>/dev/null 2>&1;then
    mkdir -p ~/.vim/bundle
    git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
    # if which git >/dev/null 2>&1; then
    #     vim -N -u NONE -i NONE -V1 -e -s --cmd "source ~/.vimrc" --cmd NeoBundleInstall! --cmd qall!
    # fi
fi

# cpanm
if ! which cpanm 1>/dev/null 2>&1;then
    source cpanm.sh
fi
cpanm --skip-installed MIME::Base64
# cpanm --skip-installed App::Ack
