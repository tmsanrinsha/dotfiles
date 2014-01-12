#!/usr/bin/env bash

set -ex

# コマンドの存在チェック
# @see コマンドの存在チェックはwhichよりhashの方が良いかも→いやtypeが最強
#      http://qiita.com/kawaz/items/1b61ee2dd4d1acc7cc94
function command_exists {
  hash "$1" 2>/dev/null;
}

# http://qiita.com/yudoufu/items/48cb6fb71e5b498b2532
git_dir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; cd ../; pwd)"
home=$git_dir/home
script_dir=$git_dir/script
setup_dir=$git_dir/setup

if [[ `uname` = CYGWIN* ]]; then
    # Windowsのメッセージの文字コードをcp932からutf-8に変更
    # なぜか英語になっちゃう
    cmd /c chcp 65001

    # lnコマンドをmklinkに変換するスクリプトを使う
    ln=$home/script/cygwin/ln
else
    ln=ln
fi

# ディレクトリの作成
for dir in `find $home -mindepth 1 -type d | sed -e "s|$home/||"`
do
    test -d ~/$dir || mkdir ~/$dir
done

# シンボリックリンクを貼る
for file in `find $home -type f ! -regex '.*swp.*' | sed "s|$home/||"`
do
    # 実体ファイルがある場合はバックアップをとる
    if [ -f ~/$file -a ! -L ~/$file ]; then
        mv ~/$file ~/${file}.bak
    fi
    # シンボリックリンクは削除
    if [ -L ~/$file ]; then
        rm ~/$file
    fi
    $ln -sv $home/$file ~/$file
done

# [ ! -f ~/.gitconfig ] && cp $gitdir/.gitconfig ~/.gitconfig

test -d ~/.zsh/functions || mkdir -p ~/.zsh/functions
test -d ~/script/common || mkdir -p ~/script/common

if [[ `uname` = CYGWIN* ]]; then
    test -d ~/script/cygwin || mkdir -p ~/script/cygwin
fi

# http://beyondgrep.com
if ! command_exists ack; then
    curl http://beyondgrep.com/ack-2.10-single-file > $HOME/bin/ack
    chmod a+x $HOME/bin/ack
fi

# [ ! -d ~/script/pseudo ] && mkdir -p ~/script/pseudo
#
# if [ ! -x ~/script/pseudo/git ];then
#     # http://d.hatena.ne.jp/hnw/20120602
#     # https://github.com/hnw/fakegit
#     curl -L https://raw.github.com/hnw/fakegit/master/bin/fakegit > ~/script/pseudo/git
#     chmod a+x $HOME/script/pseudo/git
# fi

if [[ `uname` = CYGWIN* ]]; then
    if [ ! -x ~/script/cygwin/apt-cyg ]; then
        curl https://raw.github.com/rcmdnk/apt-cyg/master/apt-cyg > ~/script/cygwin/apt-cyg
        chmod a+x ~/script/cygwin/apt-cyg
    fi

    apt_cyg="$HOME/script/cygwin/apt-cyg -m ftp://ftp.jaist.ac.jp/pub/cygwin/x86_64 -c /package"

    command_exists ssh || $apt_cyg install openssh
    command_exists mercurial || $apt_cyg install mercurial

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
    ln -fs ~/_gvimrc ~/.gvimrc
    mkdir -p ~/setting
    curl -L https://raw2.github.com/altercation/solarized/master/iterm2-colors-solarized/Solarized%20Dark.itermcolors > ~/setting/Solarized_Dark.itermcolors
    curl -L https://raw2.github.com/altercation/solarized/master/iterm2-colors-solarized/Solarized%20Light.itermcolors > ~/setting/Solarized_Light.itermcolors
    if command_exists brew; then
        ln -fs /usr/local/Library/Contributions/brew_zsh_completion.zsh ~/.zsh/functions/_brew
        command_exists ant || brew install ant
        command_exists hg || brew install mercurial
        command_exists node || brew install node
        command_exists python || brew install python
        command_exists ruby || brew install ruby
        command_exists tmux || brew install tmux
        command_exists tree || brew install tree
        command_exists zsh || brew install zsh
    fi
    # ウィンドウの整列
    if [ ! -d ~/git/ShiftIt ];then
        git clone https://github.com/fikovnik/ShiftIt.git ~/git/ShiftIt
        cd ~/git/ShiftIt && xcodebuild -target "ShiftIt NoX11" -configuration Release
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
command_exists cpanm || source $setup_dir/cpanm.sh
cpanm --skip-installed MIME::Base64
# cpanm --skip-installed App::Ack
