#!/usr/bin/env bash

# env_cache.sh {{{1
# ============================================================================
if [ -f ~/.sh/env_cache.sh ]; then
  . ~/.sh/env_cache.sh
fi

# osの判定 {{{1
# ============================================================================
if [[ "$OSTYPE" =~ darwin ]]; then
  os=mac
elif [[ "$OSTYPE" == msys ]]; then
  os=msys
else
  case "$(uname)" in
    Linux)   os='linux'   ;;
    FreeBSD) os='freebsd' ;;
    CYGWIN*) os='cygwin'  ;;
  esac
fi

function is_mac {
  [[ "$OSTYPE" =~ darwin ]]
}

# コマンドの存在チェック {{{1
# ============================================================================
# @see コマンドの存在チェックはwhichよりhashの方が良いかも→いやtypeが最強
#      http://qiita.com/kawaz/items/1b61ee2dd4d1acc7cc94
function command_exists {
  type "$1" 1>/dev/null 2>&1;
}

# hosts用の設定の出力 {{{1
function hosts {
    host $(hostname) | awk '{print $4"	#"$1}'
}

# Environment Variables 環境変数 {{{1
# ============================================================================
# CentOS 6.3の/etc/profileにあるPATHを追加する関数
pathmunge () {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            if [ "$2" = "after" ] ; then
                PATH=$PATH:$1
            else
                PATH=$1:$PATH
            fi
    esac
}

# 実行ファイルがあるディレクトリに再帰的にPATHを通す
pathmungeR () {
    if [ -d $1 ]; then
        for i in `find -L $1 -type d \( -name .git -o -name .svn -o -name .hg \) -prune -o -type f -perm -u+x -exec dirname {} \; | uniq`
        do
            pathmunge $i $2
        done
    fi
}

# pathmungeR "$HOME/script/common"
# # 正規のコマンドがないときに使う仮のコマンドを置くディレクトリ
# pathmungeR "$HOME/script/pseudo" after


if [[ "$os" = cygwin ]]; then
  # Cygwin用のコマンドを置くディレクトリ
  # pathmungeR "$HOME/script/cygwin"
  :
elif [[ "$os" == mac ]]; then
  # [.zshenv で PATH を管理したら罠にハマった - 大学生からの Web 開発](http://karur4n.hatenablog.com/entry/2016/01/18/100000)
  #
  # /etc/profileの
  #   if [ -x /usr/libexec/path_helper ]; then
  #     eval `/usr/libexec/path_helper -s`
  #   fi
  # が.zshenvの読み込み後に実行されるとPATHの順番が変わってしまうので、
  #   setopt no_global_rcs
  # を.zshenv書いて、/etc/profileが読まれないようにする。
  # しかし、
  #   eval `/usr/libexec/path_helper -s`
  # を実行しないと/usr/local/binなどのPATHが設定されないので、.zshenvより実行してやる。
  # 起動するたびに呼ぶと遅いので、すでに設定されている場合は読まないようにする。
  # if [[ -x /usr/libexec/path_helper && -z $PATH_HELPER_INIT ]]; then
  #   eval `/usr/libexec/path_helper -s`
  #   export PATH_HELPER_INIT=1
  # fi

  # やっぱり毎回読む
  if [[ -x /usr/libexec/path_helper ]]; then
    eval `/usr/libexec/path_helper -s`
  fi

  # coreutils
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

  # gnu-sed
  export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
  export MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"

  # wine
  if [ -d ~/Applications/PlayOnMac.app/Contents/Resources/unix/wine/bin ]; then
      pathmunge ~/Applications/PlayOnMac.app/Contents/Resources/unix/wine/bin after
  fi
fi

export PAGER=less

## lessのオプションの設定
# i: 検索をsmartcassにする
# R: カラーシーケンスを色に変換して表示する
export LESS='-iR'

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

# TERMの設定 {{{2
# ----------------------------------------------------------------------------
# screen-256color -> screen
# if [ $TERM = screen-256color ]; then
#     if [ "`find /usr/share/terminfo -name screen-256color`" = '' ]; then
#         export TERM='screen'
#     fi
# fi
#
# # xterm-256color -> xterm
# if [ $TERM = xterm-256color ]; then
#     if [ "`find /usr/share/terminfo -name xterm-256color`" = '' ]; then
#         export TERM='xterm'
#     fi
# fi
# }}}

# 独自設定
export SRC_ROOT=$HOME/src

# alias {{{1
# ============================================================================
# ls {{{2
# ----------------------------------------------------------------------------
alias l='ls'
alias ll='ls -l'
# . ..以外の.で始まるファイルを表示
alias la='ls -A'
alias lla='ls -la'
alias lld='ls -ld'

# Android {{{1
# ============================================================================
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"

# Git {{{1
# ============================================================================
export BROWSER=iterm-browse

# Golang {{{1
# ============================================================================
# MacでGoをパッケージからインストールした時用
if [ -d /usr/local/go/bin ]; then
    export PATH="/usr/local/go/bin:$PATH"
fi
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"

# Java {{{1
# ============================================================================
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8 -Duser.language=en"

# Elasticsearch {{{1
# ============================================================================
# [How to Install Elasticsearch on Mac OS X](https://chartio.com/resources/tutorials/how-to-install-elasticsearch-on-mac-os-x/)
export ES_HOME=/usr/local/Cellar/elasticsearch/5.4.0
export PATH=$ES_HOME/bin:$PATH

# Node.js {{{1
# ============================================================================
if command_exists npm; then
  export PATH="$HOME/node_modules/.bin:$PATH"
  alias npm-path-add='export PATH="$(npm bin):$PATH"'
fi

# Perl {{{1
# ============================================================================
# vdebug
export PERL5LIB="$HOME/perl5/lib/perl5/Komodo-PerlRemoteDebugging${PERL5LIB:+:${PERL5LIB}}"
export PERL5DB="BEGIN {require q($HOME/perl5/lib/perl5/Komodo-PerlRemoteDebugging/perl5db.pl)}"
export PERLDB_OPTS="RemotePort=localhost:9000"
export DBGP_IDEKEY="PHPSTORM"

if command_exists perl; then
    # perlモジュールの一覧表示。@INCから.（カレントディレクトリ）は取り除く
    function perl-pm-list {
      find `perl -e 'print "@INC"' | sed -e 's/ .$//'` -type f -name \"*.pm\"
    }

    function perl-pm-version {
        perl -M$1 -e 'print $'"$1::VERSION"' . "\n"'
    }

    if command_exists cpanm; then
        export PERL_CPANM_OPT="--local-lib=~/perl5"
        test -r ~/.sh/cpanm.sh && source ~/.sh/cpanm.sh
    fi
fi

# PHP {{{1
# ============================================================================
pathmunge "$HOME/.composer/vendor/bin"

# Python {{{1
# ============================================================================
export PYTHONUSERBASE="$HOME/python"
export PATH="$PYTHONUSERBASE/bin:$PATH"

# pyenv {{{2
# ----------------------------------------------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
# if command_exists pyenv; then
#   # 環境変数が設定されている場合は設定しない
#   if [[ -z $PYENV_VIRTUALENV_INIT ]]; then
#     eval "$(command pyenv init -)"
#     eval "$(command pyenv virtualenv-init -)"
#   fi

  # 必要になってから設定
  pyenv() {
    eval "$(command pyenv init -)"
    eval "$(command pyenv virtualenv-init -)"
    pyenv "$@"
  }
# fi

# IPython {{{2
# ----------------------------------------------------------------------------
# [Overview of the IPython configuration system — IPython 5.1.0 documentation](http://ipython.readthedocs.io/en/stable/development/config.html#configuration-file-location)
# defaultは~/.ipython
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"

# Rlang {{{1
# ============================================================================
export R_ENVIRON_USER="$XDG_CONFIG_HOME/R/Renviron"
test -d $XDG_CACHE_HOME/R || mkdir -p $XDG_CACHE_HOME/R
export R_HISTFILE="$XDG_CACHE_HOME/R/Rhistory"
export R_HISTSIZE="5000"

# Ruby {{{1
# ============================================================================
if [ -d /usr/local/opt/ruby/bin ]; then
    export PATH="/usr/local/opt/ruby/bin:$PATH"
fi
if [ -d /usr/local/lib/ruby/gems/2.3.0/gems/tmuxinator-0.8.1/bin ]; then
    export PATH="/usr/local/lib/ruby/gems/2.3.0/gems/tmuxinator-0.8.1/bin:$PATH"
fi

# Vim {{{1
# ============================================================================
# if [ -d /usr/local/Cellar/macvim-kaoriya/HEAD/MacVim.app/Contents/MacOS ]; then
#     macvim_dir=/usr/local/Cellar/macvim-kaoriya/HEAD/MacVim.app/Contents/MacOS
# elif [ -d /Applications/MacVim.app/Contents/MacOS ]; then
    # macvim_dir=/Applications/MacVim.app/Contents/MacOS
# fi

# if [ -x "$macvim_dir/Vim" ]; then
#     export EDITOR="$macvim_dir/Vim"
#     export PATH="$macvim_dir:$PATH"
#     alias vim="$macvim_dir/Vim"
#     unset macvim_dir
# else
#     export EDITOR='vim'
# fi

if [ -d /Applications/MacVim.app/Contents/bin ]; then
    export PATH="/Applications/MacVim.app/Contents/bin:$PATH"
fi

export EDITOR='vim'
export JUNKFILE="$HOME/work"

# postgres {{{1
# ============================================================================
if [[ "$os" = mac ]]; then
    export DATABASE_URL="postgres:///$USER"
    export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
fi

# $HOME/bin, $HOME/local/bin {{{1
# ============================================================================
# macでtmuxを起動したり、vimで!でコマンド実行をすると
# PATHの先頭に /etc/paths, /etc/paths.d以下のPATHが追加された後に
# .zshenvなどが読み込まれるようだ。
# pathmungeだと、すでにPATHにあるため追加できないのでexportで追加

# シェルスクリプトなどを置くディレクトリ
export PATH="$HOME/bin:$PATH"
# makeで作った実行ファイルなどを置くディレクトリ
export PATH="$HOME/local/bin:$PATH"

# local {{{1
# ============================================================================
if [ -f ~/.sh/env_local.sh ]; then
    . ~/.sh/env_local.sh
fi
