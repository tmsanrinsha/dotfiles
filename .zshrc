#bash, zsh共通設定の読み込み
if [ -f ~/.zashrc ]; then
    . ~/.zashrc
fi


# 重複パスの除去
# http://d.hatena.ne.jp/yascentur/20111111/1321015289
#LD_LIBRARY_PATH=${HOME}/lib:$LD_LIBRARY_PATH
#INCLUDE=${HOME}/include:$INCLUDE

[ -z "$ld_library_path" ] && typeset -T LD_LIBRARY_PATH ld_library_path
[ -z "$include" ] && typeset -T INCLUDE include
typeset -U path cdpath fpath manpath ld_library_path include


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
alias -g A='| awk'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail -f'
alias -g R='| tail -r'
alias -g V='| vim - -R'
alias -g G='| grep'
alias -g E='| egrep'
alias -g GI='| egrep -i'

## Keybind configuration
#
# emacs like keybind -e
# vi like keybind -v
bindkey -e
bindkey "^/" undo
bindkey "^[/" redo
# bindkey "\e[Z" reverse-menu-complete #zsh -Yと打って、Tabを押したら、すぐに補完する設定の時のみ有効
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

#------------------------------------------------------------------------------
# auto_pushd
#------------------------------------------------------------------------------
# auto directory pushd that you can get dirs list by cd -(+)[tab]
# -:古いのが上、+:新しいのが上
setopt auto_pushd
# cd -[tab]とcd +[tab]の役割を逆にする
setopt pushd_minus
# pushdで同じディレクトリを重複してpushしない
setopt pushd_ignore_dups

# pushdを端末間で共有したり、ログアウトしても残るようにする
# http://sanrinsha.lolipop.jp/blog/2012/02/%E3%83%87%E3%82%A3%E3%83%AC%E3%82%AF%E3%83%88%E3%83%AA%E3%82%B9%E3%82%BF%E3%83%83%E3%82%AF%E3%82%92%E7%AB%AF%E6%9C%AB%E9%96%93%E3%81%A7%E5%85%B1%E6%9C%89%E3%81%97%E3%81%9F%E3%82%8A%E3%80%81%E4%BF%9D.html
function share_pushd_preexec {
    pwd >> ~/.pushd_history
}
function share_pushd_precmd {
    # 現在のディレクトリに戻ってこれるように書き込み
    pwd >> ~/.pushd_history
    # 上の書き込みで重複が生じた場合かもしれないので重複を削除
    cat ~/.pushd_history | uniq >> ~/.pushd_history
    while read line
    do
        # ディレクトリが削除されていることもあるので調べる
        [ -d $line ] && cd $line
    done <~/.pushd_history
    # 削除されたディレクトリが取り除かれた新しいdirsを書き込む
    # 最新のを10だけ保存することにする
    dirs | tr " " "\n" | sed "s|~|${HOME}|" | tail -r | tail -n 10 > ~/.pushd_history
}
#------------------------------------------------------------------------------

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

#------------------------------------------------------------------------------
# 履歴
#------------------------------------------------------------------------------
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
setopt hist_ignore_space     # 先頭にスペースを入れると履歴に残さない

#------------------------------------------------------------------------------
# プロンプト
#------------------------------------------------------------------------------
# 改行のない出力をプロンプトで上書きするのを防ぐ
unsetopt promptcr
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

#------------------------------------------------------------------------------
# screenの設定
#------------------------------------------------------------------------------
#実行中のコマンドまたはカレントディレクトリの表示
#.screenrcでterm xterm-256colorと設定している場合
if [ $TERM = xterm-256color ];then
    screen_preexec() {
        echo -ne "\ek${1%% *}@${HOST%%.*}\e\\"
    }
    screen_precmd() {
        echo -ne "\ek$(basename $(pwd))@${HOST%%.*}\e\\"
    }
else
    screen_preexec() {
        :
    }
    screen_precmd() {
        :
    }
fi


function preexec {
    share_pushd_preexec
    screen_preexec
}

function precmd {
     share_pushd_precmd
     screen_precmd
}


if [ -f ~/.zshrc.local ]; then
    . ~/.zshrc.local
fi
