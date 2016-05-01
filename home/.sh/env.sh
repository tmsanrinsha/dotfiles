# osの判定 {{{1
# ============================================================================
case "$(uname)" in
    Linux)   os='linux'   ;;
    Darwin)  os='mac'     ;;
    FreeBSD) os='freebsd' ;;
    CYGWIN*) os='cygwin'  ;;
esac

# コマンドの存在チェック {{{1
# ============================================================================
# @see コマンドの存在チェックはwhichよりhashの方が良いかも→いやtypeが最強
#      http://qiita.com/kawaz/items/1b61ee2dd4d1acc7cc94
function command_exists {
  hash "$1" 2>/dev/null;
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

# macでtmuxを起動したり、vimで!でコマンド実行をすると
# PATHの先頭に /etc/paths, /etc/paths.d以下のPATHが追加された後に
# .zshenvなどが読み込まれるよう。
# pathmungeだと、すでにPATHにあるため追加できないのでexportで追加

# シェルスクリプトなどを置くディレクトリ
# pathmunge "$HOME/bin"
export PATH="$HOME/bin:$PATH"
# makeで作った実行ファイルなどを置くディレクトリ
export PATH="$HOME/local/bin:$PATH"

pathmunge "$HOME/.composer/vendor/bin"

pathmungeR "$HOME/script/common"
# 正規のコマンドがないときに使う仮のコマンドを置くディレクトリ
pathmungeR "$HOME/script/pseudo" after


if [[ `uname` = CYGWIN* ]]; then
    # Cygwin用のコマンドを置くディレクトリ
    pathmungeR "$HOME/script/cygwin"
elif [[ $OSTYPE == darwin* ]]; then
    # Mac用のコマンドを置くディレクトリ
    pathmungeR "$HOME/script/mac"

    pathmunge '/usr/local/sbin'

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

    # ruby
    export PATH="/usr/local/opt/ruby/bin:$PATH"
fi


# script_dir=$HOME/git/tmsanrinsha/dotfiles/script
# # シェルスクリプトなどを置くディレクトリ
# pathmungeR ${script_dir}/common
# # 正規のコマンドがないときに使う仮のコマンドを置くディレクトリ
# pathmungeR ${script_dir}/pseudo after
# # Cygwin用のコマンドを置くディレクトリ
# if [[ `uname` = CYGWIN* ]]; then
#     pathmungeR ${script_dir}/cygwin
# fi

export PAGER=less

## lessのオプションの設定
# i: 検索をsmartcassにする
# R: カラーシーケンスを色に変換して表示する
export LESS='-iR'

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

# 独自設定
export SRC_ROOT=$HOME/src

# Go language {{{1
# ============================================================================
export GOPATH=$HOME/.go
pathmunge $GOPATH/bin

# Java {{{1
# ============================================================================
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8


# R lang {{{1
# ============================================================================
export R_ENVIRON_USER="$XDG_CONFIG_HOME/R/Renviron"
test -d $XDG_CACHE_HOME/R || mkdir -p $XDG_CACHE_HOME/R
export R_HISTFILE="$XDG_CACHE_HOME/R/Rhistory"
export R_HISTSIZE="5000"

# Vim {{{1
# ============================================================================
# if [ -d /usr/local/Cellar/macvim-kaoriya/HEAD/MacVim.app/Contents/MacOS ]; then
#     macvim_dir=/usr/local/Cellar/macvim-kaoriya/HEAD/MacVim.app/Contents/MacOS
# elif [ -d /Applications/MacVim.app/Contents/MacOS ]; then
    macvim_dir=/Applications/MacVim.app/Contents/MacOS
# fi

if [ -x "$macvim_dir/Vim" ]; then
    export EDITOR="$macvim_dir/Vim"
    pathmunge $macvim_dir
    alias vim="$macvim_dir/Vim"
    unset macvim_dir
else
    export EDITOR='vim'
fi
