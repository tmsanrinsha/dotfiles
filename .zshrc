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

# グローバルエイリアス {{{
alias -g A='| awk'
alias -g L='| less -R'
alias -g H='| head'
alias -g T='| tail -f'
alias -g R='| tail -r'
alias -g V='| vim - -R'
alias -g G='| grep'
alias -g E='| egrep'
alias -g GI='| egrep -i'
alias -g X='-print0 | xargs -0'
alias -g C="2>&1 | sed -e 's/.*ERR.*/[31m&[0m/' -e 's/.*WARN.*/[33m&[0m/'"
# }}}

# zmv
# http://ref.layer8.sh/ja/entry/show/id/2694
# http://d.hatena.ne.jp/mollifier/20101227/p1
autoload -Uz zmv
alias zmv='zmv -W'


# Keybind configuration {{{
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
# }}}

# 単語境界にならない記号の設定
# /を入れないこと区切り線とみなし、Ctrl+Wで1ディレクトリだけ削除できたりする
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# auto change directory
setopt auto_cd

# auto_pushd {{{
# auto directory pushd that you can get dirs list by cd -(+)[tab]
# -:古いのが上、+:新しいのが上
setopt auto_pushd
# cd -[tab]とcd +[tab]の役割を逆にする
setopt pushd_minus
# pushdで同じディレクトリを重複してpushしない
setopt pushd_ignore_dups
# }}}

# compacked complete list display
setopt list_packed

# 履歴 {{{
#==============================================================================
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

bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

## Command history configuration
#
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data
setopt hist_ignore_space     # 先頭にスペースを入れると履歴に残さない
setopt interactive_comments # 対話シェルでコメントを使えるようにする
# }}}

#==============================================================================
# precmd系 {{{
#==============================================================================
# http://d.hatena.ne.jp/kiririmode/20120327/p1
# add-zsh-hook precmd functionするための設定
autoload -Uz add-zsh-hook

# プロンプト {{{
#==============================================================================
# 改行のない出力をプロンプトで上書きするのを防ぐ
unsetopt promptcr
setopt print_exit_value
autoload -Uz colors; colors

# 現在のホストによってプロンプトの色を変える。
# 256色の内、カラーで背景黒の時見やすい色はこの217色かな
colArr=({1..6} {9..14} {22..186} {190..229})

# hostnameをmd5でハッシュに変更し、1-217の数値を生成する
# hostnameが長いとエラーが出るので最初の8文字を使う
if [ `uname` = FreeBSD ];then
    num=$((0x`hostname | md5 | cut -c1-8` % 217 + 1)) # zshの配列のインデックスは1から
else
    num=$((0x`hostname | md5sum | cut -c1-8` % 217 + 1))
fi

color="%{"$'\e'"[38;5;${colArr[$num]}m%}"

#C-zでサスペンドしたとき(18)以外のエラー終了時に(;_;)!を表示
local err="%0(?||%18(?||%{$fg[red]%}(;_;%)!%{${reset_color}%}"$'\n'"))"


#function prompt_preexec() {
#    # preexecの中で
#    #  $0はpreexec
#    #  $1は入力されたコマンド
#    #  $2は入力されたエイリアスが展開されたコマンド
#    # setopt print_exit_valueと挙動を似せるために$2をとっておく
#    prompt_cmd=$2
#}
function prompt_precmd() {
    ## setopt print_exit_valueをセットしたときのようなメッセージを作る
    ## ただし、setopt print exit_valueの場合はcommand1;command2と打った時
    #err="%0(?||%18(?||%{$fg[red]%}(;_;%)! zsh: exit $?   $prompt_cmd%{${reset_color}%}"$'\n'"))"
    err="%0(?||%18(?||%{$fg[red]%}(;_;%)!%{${reset_color}%}"$'\n'"))"
    # パスの~の部分の色を反転させる
    tildepwd=$(pwd | sed "s|$HOME|%S~%s|")
    PROMPT="${err}${color}[%m:${tildepwd}]%#%{${reset_color}%} "
}
#add-zsh-hook preexec prompt_preexec
add-zsh-hook precmd prompt_precmd

PROMPT2="${color}%_>%{${reset_color}%} "
# command correct edition before each completion attempt
setopt correct
SPROMPT="%{$fg[yellow]%}(._.%)? %r is correct? [n,y,a,e]:%{${reset_color}%} "

# 参考にしたサイト
# ■zshで究極のオペレーションを：第3回　zsh使いこなしポイント即効編｜gihyo.jp … 技術評論社
#  - http://gihyo.jp/dev/serial/01/zsh-book/0003
#  - C-zでサスペンドしたとき(18)以外のエラー終了時の設定を参考にした
#  - エスケープシーケンスの記述、プロンプトで使える特殊文字の表がある
# ■【コラム】漢のzsh (2) 取りあえず、プロンプトを整えておく。カッコつけたいからね | エンタープライズ | マイナビニュース
#  - http://news.mynavi.jp/column/zsh/002/index.html
#  - SPROMPTの設定
# ■zshでログイン先によってプロンプトに表示されるホスト名の色を自動で変える - absolute-area
#  - http://absolute-area.com/post/6664864690/zsh
# ■The 256 color mode of xterm
#  - http://frexx.de/xterm-256-notes/
# ■可愛いzshの作り方 - プログラムモグモグ
#  - http://d.hatena.ne.jp/itchyny/20110629/1309355617
#  - 顔文字を参考にした
# }}}

# set terminal title including current directory {{{
#==============================================================================
case "${TERM}" in
kterm*|xterm)
    terminal_title_precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    add-zsh-hook precmd terminal_title_precmd
    ;;
esac
# }}}

# screenの設定 {{{
#==============================================================================
#実行中のコマンドまたはカレントディレクトリの表示
#.screenrcでterm xterm-256colorと設定している場合
if [ $TERM = xterm-256color ];then
    screen_preexec() {
        echo -ne "\ek${1%% *}@${HOST%%.*}\e\\"
    }
    screen_precmd() {
        echo -ne "\ek$(basename $(pwd))@${HOST%%.*}\e\\"
    }
    add-zsh-hook preexec screen_preexec
    add-zsh-hook precmd screen_precmd
fi
# }}}

# pushdを端末間で共有したり、ログアウトしても残るようにする {{{
#==============================================================================
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
add-zsh-hook preexec share_pushd_preexec
add-zsh-hook precmd share_pushd_precmd
# }}}
# }}}

if [ -f ~/.zshrc.local ]; then
    . ~/.zshrc.local
fi
