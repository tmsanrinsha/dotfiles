#bash, zsh共通設定の読み込み
if [ -f ~/.zashrc ]; then
    . ~/.zashrc
fi

#補完
autoload -U compinit
compinit
zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
# Incremental completion on zsh
# http://mimosa-pudica.net/zsh-incremental.html
if [ -f ~/.zsh/plugin/incr-0.2.zsh ]; then
    . ~/.zsh/plugin/incr-0.2.zsh
fi

#グローバルエイリアス
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g GI='| grep -i'

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

# 単語境界にならない記号の設定
# /を入れないこと区切り線とみなし、Ctrl+Wで1ディレクトリだけ削除できたりする
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -(+)[tab]
# -:古いのが上、+:新しいのが上
setopt auto_pushd
# cd -[tab]とcd +[tab]の役割を逆にする
setopt pushd_minus

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

#----------------------------------------------------------
# 履歴
#----------------------------------------------------------
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
# プロンプト
#----------------------------------------------------------
#C-zでサスペンドしたとき(18)以外のエラー終了時に%#を赤く表示
local pct="%0(?||%18(?||%{"$'\e'"[31m%}))%#%{"$'\e'"[m%}"

# Solarized
# https://github.com/seebi/dircolors-solarized
# 現在のホストによってプロンプトの色を変える。
# http://absolute-area.com/post/6664864690/zshを参考にした
if [ `uname` = FreeBSD ];then
    colnum=$((0x`hostname | md5 | cut -c1` % 8))
else
    colnum=$((0x`hostname | md5sum | cut -c1` % 8))
fi
# `hostname | md5 | cut -c1`
# hostnameをmd5でハッシュに変更して、最初の一文字を取る
# $((0x`...` % 8))
# これを16進法の数値にして8の余りを求める。
# 8の余りを求めたのはsolarizedの8色だけ使いたいので
case $colnum in
    0) col=136;;  # yellow   
    1) col=166;;  # brred    
    2) col=160;;  # red      
    3) col=125;;  # magenta  
    4) col=61;;   # brmagenta
    5) col=33;;   # blue     
    6) col=37;;   # cyan     
    7) col=64;;   # green    
esac

# 現在のホストによってプロンプトの色を変える。
# http://absolute-area.com/post/6664864690/zshを参考にした
#if [ `uname` = FreeBSD ];then
#    col=$((0x`hostname | md5 | cut -c1-8` % 214 + 17))
#else
#    col=$((0x`hostname | md5sum | cut -c1-8` % 214 + 17))
#fi
# hostnameをmd5でハッシュに変更する
# 長いとエラーが出るので最初の8文字を使う
# 0-15はdefault terminal color、
# 最後の24色はグレースケールなのでこれを取り除いた226色だが
# 最初と最後の方は見にくので17-230までを使う
# xtermの色についてはこちら
# http://frexx.de/xterm-256-notes/

#PROMPT="%{"$'\e'"[${col}m%}[%n@%m:%~]$pct " 
PROMPT="%{"$'\e'"[38;5;${col}m%}[%m:%~]$pct " 
PROMPT2="%{"$'\e'"[38;5;${col}m%}%_%#%{"$'\e'"[m%} " 
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

#----------------------------------------------------------
# screenの設定
#----------------------------------------------------------
#実行中のコマンドまたはカレントディレクトリの表示
#.screenrcでterm xterm-256colorと設定している場合
if [ $TERM = xterm-256color ];then
    preexec() {
        echo -ne "\ek${1%% *}@${HOST%%.*}\e\\"
    }
    precmd() {
        echo -ne "\ek$(basename $(pwd))@${HOST%%.*}\e\\"
    }
fi


if [ -f ~/.zshrc.local ]; then
    . ~/.zshrc.local
fi
