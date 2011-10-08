
#補完
autoload -U compinit
compinit
zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'

export LSCOLORS=ExFxCxdxBxegedabagacad
alias ls="ls -G"

## Environment variable configuration
#
# LANG
#
export LANG=ja_JP.UTF-8
#export LANG=ja_JP.eucJP

#export PAGER=/usr/local/share/vim/vim73/macros/less.sh
#export PAGER=less
# lessで色つきの表示に対応させる
export LESS='-R'

## Keybind configuration
#
# emacs like keybind -e
# vi like keybind -v
bindkey -e

# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed


## Default shell configuration
#
# set prompt
#
# 現在のホストによってプロンプトの色を変える。
case `hostname` in
    localhost.com) col=33;;  # 黄
    water) col=36;;  # 水色
    green) col=32;;  # 緑
    *) col=35;; # それ以外のホストは紫
esac

#C-zでサスペンドしたとき(18)以外のエラー終了時に%#を赤く表示
local pct="%0(?||%18(?||%{"$'\e'"[31m%}))%#%{"$'\e'"[m%}"
PROMPT="%{"$'\e'"[${col}m%}[%n@%m:%~]$pct " 
PROMPT2="%{"$'\e'"[${col}m%}%_%#%{"$'\e'"[m%} " 
#PROMPT="%{"$'\e'"[33m%}[%n@%m:%~]$pct " 
#PROMPT2="%{"$'\e'"[33m%}%_%#%{"$'\e'"[m%} " 
SPROMPT="%{"$'\e'"[31m%}%r is correct? [y,n,a,e]:%{"$'\e'"[m%} "

# set terminal title including current directory
#
case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

 
# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
#カーソル位置が行末になったほうがいい人は
#history-beginning-search-backward-end
#history-beginning-search-forward-end
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward


## Command history configuration
#
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

#manのpagerとしてvimの:Manを使う。
#.vimrcにも設定が必要
#http://vim.wikia.com/wiki/Using_vim_as_a_man-page_viewer_under_Unix
export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

#----------------------------------------------------------
# screenの設定
#----------------------------------------------------------
#screenの自動起動
if [ $SHLVL = 1 ];then
    screen
fi

#実行中のコマンドまたはカレントディレクトリの表示
#.screenrcでterm xterm-256colorと設定している場合
if [ $TERM = xterm-256color ];then
    preexec() {
        echo -ne "\ek#${1%% *}\e\\"
    }
    precmd() {
        echo -ne "\ek$(basename $(pwd))\e\\"
    }
fi
