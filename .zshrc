#bash, zsh共通設定の読み込み
if [ -f ~/.bashrc ]; then
    . ~/.zashrc
fi

#補完
autoload -U compinit
compinit
zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'

## Keybind configuration
#
# emacs like keybind -e
# vi like keybind -v
bindkey -e
#DELで一文字削除
bindkey "^[[3~" delete-char
#HOMEは行頭へ
bindkey "^[[1~" beginning-of-line
#Endで行末へ
bindkey "^[[4~" end-of-line

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

#C-zでサスペンドしたとき(18)以外のエラー終了時に%#を赤く表示
local pct="%0(?||%18(?||%{"$'\e'"[31m%}))%#%{"$'\e'"[m%}"
#PROMPT="%{"$'\e'"[${col}m%}[%n@%m:%~]$pct " 
PROMPT="%{"$'\e'"[${col}m%}[%m:%~]$pct " 
PROMPT2="%{"$'\e'"[${col}m%}%_%#%{"$'\e'"[m%} " 
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

#----------------------------------------------------------
# screenの設定
#----------------------------------------------------------
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


if [ -f ~/.zsh_option ]; then
    . ~/.zsh_option
fi
