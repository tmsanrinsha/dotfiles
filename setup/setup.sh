#!/usr/bin/env bash

set -eux

all=0
while getopts a OPT
do
  case $OPT in
    "a" ) all=1 ;;
  esac
done

# コマンドの存在チェック
# @see コマンドの存在チェックはwhichよりhashの方が良いかも→いやtypeが最強
#      http://qiita.com/kawaz/items/1b61ee2dd4d1acc7cc94
function command_exists {
  hash "$1" 2>/dev/null;
}

# http://qiita.com/yudoufu/items/48cb6fb71e5b498b2532
git_dir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; cd ../; pwd)"
home=$git_dir/home
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
if ctags --version | grep Development; then
    $ln -sfv $git_dir/template/.ctags.dev ~/.ctags
else
    $ln -sfv $git_dir/template/.ctags.old ~/.ctags
fi

# http://beyondgrep.com
if ! command_exists ack; then
    curl http://beyondgrep.com/ack-2.10-single-file > $HOME/bin/ack
    chmod a+x $HOME/bin/ack
fi

test -d ~/.zsh/functions   || mkdir -p ~/.zsh/functions
test -d ~/.zsh/completions || mkdir -p ~/.zsh/completions

if [ ! -x ~/.zsh/completions/_pandoc ];then
    # https://gist.github.com/sky-y/3334048
    curl -kL https://gist.githubusercontent.com/sky-y/3334048/raw/e2a0f9ef67c3097b3034f022d03165d9ac4fb604/_pandoc > ~/.zsh/completions/_pandoc
    chmod a+x ~/.zsh/completions/_pandoc
fi

# [ ! -d ~/script/pseudo ] && mkdir -p ~/script/pseudo
#
# if [ ! -x ~/script/pseudo/git ];then
#     # http://d.hatena.ne.jp/hnw/20120602
#     # https://github.com/hnw/fakegit
#     curl -L https://raw.github.com/hnw/fakegit/master/bin/fakegit > ~/script/pseudo/git
#     chmod a+x $HOME/script/pseudo/git
# fi

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
# command_exists cpanm || source $setup_dir/cpanm.sh
# cpanm --skip-installed MIME::Base64
# cpanm --skip-installed App::Ack

uname=`uname`
if [[ "$uname" = CYGWIN* ]]; then
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
elif [[ "$uname" = Darwin ]]; then
    ln -fs ~/_gvimrc ~/.gvimrc
    if [ ! -x ~/bin/rmtrash ];then
        curl -L https://raw.githubusercontent.com/dankogai/osx-mv2trash/master/bin/mv2trash > ~/bin/rmtrash
        chmod a+x ~/bin/rmtrash
    fi
    mkdir -p ~/setting
    curl -L https://raw2.github.com/altercation/solarized/master/iterm2-colors-solarized/Solarized%20Dark.itermcolors > ~/setting/Solarized_Dark.itermcolors
    curl -L https://raw2.github.com/altercation/solarized/master/iterm2-colors-solarized/Solarized%20Light.itermcolors > ~/setting/Solarized_Light.itermcolors
    if command_exists brew; then
        ln -fs /usr/local/Library/Contributions/brew_zsh_completion.zsh ~/.zsh/completions/_brew

        if [ $all -eq 1 ]; then
            brew update  # homebrewの更新
            brew tap caskroom/cask
            brew tap Homebrew/python
            brew upgrade # packageの更新
        fi

        brew install ant
        brew install mercurial
        brew install node
        brew install python
        brew install ruby
        brew install tmux
        brew install tree
        brew install zsh

        # phinze/homebrew-cask
        brew install brew-cask
        brew cask install bettertouchtool
        brew cask install eclipse-ide
        brew cask install pandoc

        # Homebrew/python
        brew install numpy
        # pip install nosy
        # pip install ipython
    fi
    # ウィンドウの整列
    if [ ! -d ~/git/ShiftIt ];then
        git clone https://github.com/fikovnik/ShiftIt.git ~/git/ShiftIt
        # x11のサポートなしだとbuildできる
        pushd ~/git/ShiftIt && xcodebuild -target "ShiftIt NoX11" -configuration Release
        popd
    fi
fi

# vimperator {{{1
if [[ "$uname" = CYGWIN* || "$uname" = Darwin ]]; then
    if [[ "$uname" = CYGWIN* ]]; then
        vimperatordir="$HOME/vimperator"
    else
        vimperatordir="$HOME/.vimperator"
    fi

    # if [ ! -d "$vimperatordir/vimppm/vimppm" ]; then
    #     mkdir -p "$vimperatordir/vimppm"
    #     pushd "$vimperatordir/vimppm"
    #     git clone git://github.com/cd01/vimppm
    # else
    #     pushd "$vimperatordir/vimppm/vimppm"
    #     git pull
    # fi
    # popd

    if [ ! -d ~/git/vimperator-plugins ]; then
        git clone -b 3.6 git://github.com/vimpr/vimperator-plugins.git ~/git/vimperator-plugins
        if [ ! -d "$vimperatordir/plugin" ]; then
            mkdir -p "$vimperatordir/plugin"
        fi
    else
        pushd ~/git/vimperator-plugins
        git pull
        popd
    fi
    $ln -fs ~/git/vimperator-plugins/_libly.js $vimperatordir/plugin
    # :open node.jsなどをURL判定させない
    $ln -fs ~/git/vimperator-plugins/prevent-pseudo-domain.js $vimperatordir/plugin
    # migemoを使う
    # リンクにフォーカスしない
    # $ln -fs ~/git/vimperator-plugins/migemized_find.js $vimperatordir/plugin
    # $ln -fs ~/git/vimperator-plugins/migemo_completion.js $vimperatordir/plugin
    # $ln -fs ~/git/vimperator-plugins/migemo_hint.js $vimperatordir/plugin
    # テキストボックスにフォーカスさせない
    # $ln -fs ~/git/vimperator-plugins/forcefocuscontent.js $vimperatordir/plugin
fi
