#!/usr/bin/env bash
set -ex

# macのcronでPATHを設定するため
# 最近のMac OSXで、PATHをスマート(?)に管理するやり方。 - こせきの技術日記
# - http://koseki.hatenablog.com/entry/20081201/macportPath
if [ -x /usr/libexec/path_helper ]; then
  eval `/usr/libexec/path_helper -s`
fi

brew=0
link=0
while getopts bl OPT
do
  case $OPT in
    "b")
        brew=1;;
    "l")
        link=1;;
  esac
done

# http://qiita.com/yudoufu/items/48cb6fb71e5b498b2532
git_dir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; cd ../; pwd)"
cd $git_dir
git pull
home=$git_dir/home
setup_dir=$git_dir/setup

source $home/.sh/env.sh

if command_exists curl;then
    downloader='curl -kLR'
elif command_exists wget;then
    downloader='wget --no-check-certificate -O -'
else
    echo 'curlまたはwgetをインストールしてください'
    exit 1
fi

function install() {
  local url=$1
  local file
  if [ -z "$2" ]; then
      file=`basename $url`
  else
      file=$2
  fi

  if ! type $file 1>/dev/null 2>&1; then
    $downloader $url > $HOME/bin/$file
    chmod a+x $HOME/bin/$file
  fi
}

function myplug() {
    local plugin=$1
    local dir=$2

    if type git 1>/dev/null 2>&1; then
        return
    fi

    if [ ! -d $dir ]; then
        git clone $plugin $dir
    else
        cd $dir
        git pull
    fi
}

function error {
    echo -e "\e[31m$1\e[m"
}

# 設定ファイルにシンボリックリンクを貼る {{{1
# ============================================================================
# [ディレクトリ内のファイル1つ1つに対して一気にシンボリックリンクを作成する - Qiita](http://qiita.com/krsak/items/394850608ffe530cd6b2)
# lndirのシェルスクリプト版がある
if command_exists lndir; then
  lndir $home ~
else
  $home/bin/makelink.sh $home
fi

# vim {{{2
# ----------------------------------------------------------------------------
if [ $os == mac ]; then
    ln -fs ~/_gvimrc ~/.gvimrc
fi

# .gitconfigの設定 {{{2
# ----------------------------------------------------------------------------
if [ -f ~/.gitconfig -a ! -L ~/.gitconfig ]; then
    mv ~/.gitconfig{,.bak}
fi
cp $git_dir/sample/.gitconfig ~/.gitconfig

# 消し方
# git config --global --remove-section "ghq" || :
# git config --global --unset ghq.root
# git config --global "ghq.root" "$SRC_ROOT"

# .ctagsの設定 {{{2
# ----------------------------------------------------------------------------
if [ -L "$HOME/.ctags" ]; then
    rm "$HOME/.ctags"
fi
if ctags --version | grep Development; then
    $setup_dir/make_.ctags.sh --new > ~/.ctags
else
    $setup_dir/make_.ctags.sh --old > ~/.ctags
fi
# }}}

if [ $link -eq 1 ]; then
    exit
fi

# GitHubのreleaseパッケージのインストールスクリプト
if [ ! -d $SRC_ROOT/github.com/tmsanrinsha/ghinst/.git ]; then
    cd $SRC_ROOT/github.com/tmsanrinsha
    git clone https://github.com/tmsanrinsha/ghinst.git
    ln -sf $SRC_ROOT/github.com/tmsanrinsha/ghinst/ghinst ~/bin/
fi
# こういうのもある
# b4b4r07/cli
# https://github.com/b4b4r07/cli

command_exists ghq || ghinst motemen/ghq || error 'Failed: ghinst motemen/ghq'

ghq get -u tmsanrinsha/tmux_multi
ln -sf $SRC_ROOT/github.com/tmsanrinsha/tmux_multi/tmux_multi ~/bin

# zsh {{{1
# ============================================================================
export ZDOTDIR=${HOME}/.zsh
test -d $ZDOTDIR/.cache      || mkdir -p $ZDOTDIR/.cache
test -d $ZDOTDIR/functions   || mkdir -p $ZDOTDIR/functions
test -d $ZDOTDIR/load   || mkdir -p $ZDOTDIR/load

if command_exists npm && ! test -f $ZDOTDIR/load/npm.zsh ; then
    npm completion > $ZDOTDIR/load/npm.zsh
fi

if command_exists kubectl && ! test -f $ZDOTDIR/load/kubectl.zsh ; then
    kubectl completion zsh > $ZDOTDIR/load/kubectl.zsh
fi

# vimperator {{{1
# ============================================================================
if [[ `uname` = CYGWIN* || `uname` = Darwin ]]; then
    if [[ `uname` = CYGWIN* ]]; then
        vimperatordir="$HOME/vimperator"
    else
        vimperatordir="$HOME/.vimperator"
    fi

    ghq get -u vimpr/vimperator-plugins
    ln -fs ~/src/github.com/vimpr/vimperator-plugins/plugin_loader.js $vimperatordir/plugin
fi

# script {{{1
# ============================================================================
install 'https://cdn.rawgit.com/harelba/q/1.5.0/bin/q'
install 'https://raw.githubusercontent.com/mla/ip2host/master/ip2host'
install 'https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/tools/screenshotTable.sh'

if [ $os == mac ]; then
    url='https://github.com/stedolan/jq/releases/download/jq-1.5/jq-osx-amd64'
elif [ $os == linux ]; then
    url='https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64'
fi
install $url jq

command_exists pt     || ghinst monochromegane/the_platinum_searcher
command_exists jvgrep || ghinst mattn/jvgrep

if ! command_exists peco; then
    ghinst peco/peco
fi

if ! command_exists migemogrep; then
    ghinst peco/migemogrep
fi

ghq get -u motemen/ghq

if [ -f ~/src/github.com/motemen/ghq/zsh/_ghq ]; then
    ln -fs ~/src/github.com/motemen/ghq/zsh/_ghq ~/.zsh/functions
fi
if [ -f ~/go/src/github.com/motemen/ghq/zsh/_ghq ]; then
    ln -fs ~/go/src/github.com/motemen/ghq/zsh/_ghq ~/.zsh/functions
fi

# grep系 {{{1
# ============================================================================
# http://beyondgrep.com
if ! command_exists ack; then
    $downloader http://beyondgrep.com/ack-2.10-single-file > $HOME/bin/ack
    chmod a+x $HOME/bin/ack
fi

# cpanm {{{1
# ============================================================================
# command_exists cpanm || source $setup_dir/cpanm.sh
# cpanm --skip-installed MIME::Base64
# cpanm --skip-installed App::Ack

# CYGWIN {{{1
# ============================================================================
if [[ `uname` = CYGWIN* ]]; then
    if [ ! -x ~/script/cygwin/apt-cyg ]; then
        $downloader https://raw.github.com/rcmdnk/apt-cyg/master/apt-cyg > ~/script/cygwin/apt-cyg
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
        $downloader https://github.com/downloads/cuviper/ssh-pageant/ssh-pageant-1.1-release.tar.gz | tar  zxvf -
        cd ssh-pageant-1.1
        cp ssh-pageant.exe /usr/bin/
        cp ssh-pageant.1 /usr/share/man/man1/
        popd
    fi

# mac {{{1
# ============================================================================
elif [ $os == mac ]; then
    if [ ! -x ~/bin/rmtrash ];then
        $downloader https://raw.githubusercontent.com/dankogai/osx-mv2trash/master/bin/mv2trash > ~/bin/rmtrash
        chmod a+x ~/bin/rmtrash
    fi

    myplug https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    if [ ! -d $SRC_ROOT/github.com/tmsanrinsha/edit-server ]; then
        ghq get tmsanrinsha/edit-server
        launchctl load ~/Library/LaunchAgents/edit-server.plist
    fi

    if [ $brew -eq 1 ]; then
        cd $setup_dir
        ./brew.sh -b
    fi
fi

# python {{{1
# ============================================================================
# pip3 install numpy
# pip3 install scipy
# pip3 install matplotlib
# pip3 install scikit-lern

# remote2local {{{1
# ============================================================================
# if ghq get https://github.com/tmsanrinsha/remote2local | grep -v exists; then
# if [ ! -d $SRC_ROOT/tmsanrinsha/remote2local ]; then
#     git clone https://github.com/tmsanrinsha/remote2local.git $SRC_ROOT/tmsanrinsha/remote2local
#     if [ `uname` = Darwin ]; then
#         ln -fs $SRC_ROOT/tmsanrinsha/remote2local/Library/LaunchAgents/rfrouter.plist ~/Library/LaunchAgents/rfrouter.plist
#         launchctl load ~/Library/LaunchAgents/rfrouter.plist
#     fi
#     ln -fs $SRC_ROOT/tmsanrinsha/remote2local/bin/* ~/bin
# else
#     pushd $SRC_ROOT/tmsanrinsha/remote2local
#     git pull
#     popd
# fi
