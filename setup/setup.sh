#!/usr/bin/env bash

set -ex

all=0
while getopts a OPT
do
  case $OPT in
    "a" ) all=1 ;;
  esac
done

# http://qiita.com/yudoufu/items/48cb6fb71e5b498b2532
git_dir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; cd ../; pwd)"
home=$git_dir/home
setup_dir=$git_dir/setup

source $home/.zashenv

# 設定ファイルにシンボリックリンクを貼る {{{1
# ============================================================================
if [[ `uname` = CYGWIN* ]]; then
    # Windowsのメッセージの文字コードをcp932からutf-8に変更
    # なぜか英語になっちゃう
    cmd /c chcp 65001

    # lnコマンドをmklinkに変換するスクリプトを使う
    ln=$home/script/cygwin/ln
else
    ln=ln
fi

cd $home
# ディレクトリがなければ作る
# 空白ではなくヌル文字で区切る
while IFS= read -r -d '' dir; do
    dir=${dir#./}
    test -d "$HOME/$dir" || mkdir "$HOME/$dir"
done < <(find . -mindepth 1 -type d -print0)

# シンボリックリンクを貼る
while IFS= read -r -d '' file; do
    file=${file#./}
    # 実体ファイルがある場合はバックアップをとる
    if [ -f "$HOME/$file" -a ! -L "$HOME/$file" ]; then
        mv "$HOME/$file" "$HOME/${file}.bak"
    fi
    # シンボリックリンクは削除
    if [ -L "$HOME/$file" ]; then
        rm "$HOME/$file"
    fi
    $ln -sv "$home/$file" "$HOME/$file"
done < <(find . -type f ! -regex '.*swp.*' -print0)

if [ -f ~/.gitconfig -a ! -L ~/.gitconfig ]; then
    mv ~/.gitconfig{,.bak}
fi
cp $git_dir/template/.gitconfig ~/.gitconfig
# git config --global --remove-section "ghq" || :
# git config --global "ghq.root" "$SRC_ROOT"

if ctags --version | grep Development; then
    $ln -sfv $git_dir/template/.ctags.dev ~/.ctags
else
    $ln -sfv $git_dir/template/.ctags.old ~/.ctags
fi

# zsh {{{1
# ============================================================================
test -d ~/.zsh/functions   || mkdir -p ~/.zsh/functions
test -d ~/.zsh/completions || mkdir -p ~/.zsh/completions

if [ ! -x ~/.zsh/functions/_pandoc ];then
    # https://gist.github.com/sky-y/3334048
    curl -kL https://gist.githubusercontent.com/sky-y/3334048/raw/e2a0f9ef67c3097b3034f022d03165d9ac4fb604/_pandoc > ~/.zsh/functions/_pandoc
    chmod a+x ~/.zsh/functions/_pandoc
fi

# vim {{{1
# ============================================================================
if [ ! -d ~/.vim/bundle/neobundle.vim ] && which git 1>/dev/null 2>&1;then
    mkdir -p ~/.vim/bundle
    git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
    # if which git >/dev/null 2>&1; then
    #     vim -N -u NONE -i NONE -V1 -e -s --cmd "source ~/.vimrc" --cmd NeoBundleInstall! --cmd qall!
    # fi
fi
if [[ `uname` = Darwin ]]; then
    ln -fs ~/_gvimrc ~/.gvimrc
fi

# vimperator {{{1
# ============================================================================
if [[ `uname` = CYGWIN* || `uname` = Darwin ]]; then
    if [[ `uname` = CYGWIN* ]]; then
        vimperatordir="$HOME/vimperator"
    else
        vimperatordir="$HOME/.vimperator"
    fi

    if [ ! -d ~/git/vimperator-plugins ]; then
        if [ ! -d "$vimperatordir/plugin" ]; then
            mkdir -p "$vimperatordir/plugin"
        fi
        git clone -b 3.6 git://github.com/vimpr/vimperator-plugins.git ~/git/vimperator-plugins
    else
        pushd ~/git/vimperator-plugins
        git pull
        popd
    fi

    $ln -fs ~/git/vimperator-plugins/plugin_loader.js $vimperatordir/plugin
fi

# ack {{{1
# ============================================================================
# http://beyondgrep.com
if ! command_exists ack; then
    curl http://beyondgrep.com/ack-2.10-single-file > $HOME/bin/ack
    chmod a+x $HOME/bin/ack
fi

# screenshotTable.sh {{{1
# ============================================================================
# https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/tools/screenshotTable.sh
if ! command_exists screenshotTable.sh; then
    curl https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/tools/screenshotTable.sh > $HOME/bin/screenshotTable.sh
    chmod a+x $HOME/bin/screenshotTable.sh
fi

# peco {{{1
# ============================================================================
# macの場合はhomebrewでインストールする
if ! command_exists peco && [ `uname` = Linux ]; then
    mkdir -p ~/local/{src,bin}
    pushd .
    cd ~/local/src
    curl -L 'https://github.com/peco/peco/releases/download/v0.2.0/peco_linux_amd64.tar.gz' | gzip -dc | tar xf -
    ln -s ~/local/src/peco_linux_amd64/peco ~/local/bin
    popd
fi

# cpanm {{{1
# ============================================================================
# command_exists cpanm || source $setup_dir/cpanm.sh
# cpanm --skip-installed MIME::Base64
# cpanm --skip-installed App::Ack

# install {{{1
# ============================================================================
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
    if [ ! -x ~/bin/rmtrash ];then
        curl -L https://raw.githubusercontent.com/dankogai/osx-mv2trash/master/bin/mv2trash > ~/bin/rmtrash
        chmod a+x ~/bin/rmtrash
    fi
    mkdir -p ~/setting
    curl -L https://raw2.github.com/altercation/solarized/master/iterm2-colors-solarized/Solarized%20Dark.itermcolors > ~/setting/Solarized_Dark.itermcolors
    curl -L https://raw2.github.com/altercation/solarized/master/iterm2-colors-solarized/Solarized%20Light.itermcolors > ~/setting/Solarized_Light.itermcolors
    if command_exists brew; then
        ln -fs /usr/local/Library/Contributions/brew_zsh_completion.zsh ~/.zsh/completions/_brew

        # すでにinstallされているとエラーが出るため、コマンドがあるかをチェックしてからインストール
        function brew-install {
            brew list $1 >/dev/null || brew install $1
        }
        function brew-cask-install {
            brew cask list $1 >/dev/null || brew cask install $1
        }

        if [ $all -eq 1 ]; then
            brew update  # homebrewの更新
            brew tap caskroom/cask
            brew tap peco/peco
            brew upgrade # packageの更新
        fi

        brew-install ag
        brew-install ant
        brew-install coreutils
        brew-install gnu-sed
        brew-install go
        brew-install jq
        brew-install mercurial
        brew-install nkf
        brew-install node
        brew-install pwgen
        brew-install python
        brew-install ruby
        brew-install tmux
        brew-install tree
        brew-install zsh

        # caskroom/cask
        brew-install brew-cask
        brew-cask-install alfred
        brew-cask-install bettertouchtool
        brew-cask-install eclipse-ide
        # formuraでもinstallできる
        brew-cask-install pandoc

        # peco/peco
        # formulaがないと言われる
        # brew install peco

        brew-install matplotlib
        # brew install pythonでインストールされるpipでインストール
        # 失敗
        # pip install numpy
        # pip install nosy
        # pip install ipython
        # pip install six
    fi
    # ウィンドウの整列
    # if [ ! -d ~/git/ShiftIt ];then
    #     git clone https://github.com/fikovnik/ShiftIt.git ~/git/ShiftIt
    #     # x11のサポートなしだとbuildできる
    #     pushd ~/git/ShiftIt && xcodebuild -target "ShiftIt NoX11" -configuration Release
    #     popd
        popd
    fi
fi

# remote2local {{{1
# ============================================================================
# if ghq get https://github.com/tmsanrinsha/remote2local | grep -v exists; then
if [ ! -d $SRC_ROOT/tmsanrinsha/remote2local ]; then
    git clone https://github.com/tmsanrinsha/remote2local.git $SRC_ROOT/tmsanrinsha/remote2local
    if [ `uname` = Darwin ]; then
        ln -fs $SRC_ROOT/tmsanrinsha/remote2local/Library/LaunchAgents/rfrouter.plist ~/Library/LaunchAgents/rfrouter.plist
        launchctl load ~/Library/LaunchAgents/rfrouter.plist
    fi
    ln -fs $SRC_ROOT/tmsanrinsha/remote2local/bin/* ~/bin
else
    pushd $SRC_ROOT/tmsanrinsha/remote2local
    git pull
    popd
fi
