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

# 基本設定 {{{
# ファイルがある場合のリダイレクト(>)の防止
# したい場合は>!を使う
setopt noclobber
# }}}

# Keybind configuration {{{
#
# emacs like keybind -e
# vi    like keybind -v
bindkey -e
bindkey "^/" undo
bindkey "^[/" redo
bindkey "^[v" quoted-insert
#DELで一文字削除
bindkey "^[[3~" delete-char
#HOMEは行頭へ
bindkey "^[[1~" beginning-of-line
#Endで行末へ
bindkey "^[[4~" end-of-line
# }}}

# エイリアス {{{
alias rr='exec zsh -l'
# グローバルエイリアス {{{
alias -g A='| awk'
alias -g L='| less -R'
alias -g H='| head'
alias -g T='| tail -f'
alias -g R='| tail -r'
alias -g V='| vim -R -'
alias -g G='| grep'
alias -g E='| egrep'
alias -g GI='| egrep -i'
alias -g X='-print0 | xargs -0'
alias -g C="2>&1 | sed -e 's/.*ERR.*/[31m&[0m/' -e 's/.*WARN.*/[33m&[0m/'"
alias -g TGZ='| gzip -dc | tar xf -'
# }}}
# }}}

# 補完 {{{
autoload -U compinit && compinit
zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
# 補完対象が2つ以上の時、選択できるようにする
zstyle ':completion:*:default' menu select=2
#bindkey '^i'    menu-expand-or-complete # 一回のCtrl+I or Tabで補完メニューの最初の候補を選ぶ
bindkey "\e[Z" reverse-menu-complete # Shift-Tabで補完メニューを逆に選ぶ
zstyle ':completion:*' use-cache true

# Incremental completion on zsh
# http://mimosa-pudica.net/zsh-incremental.html
if [ -f ~/.zsh/plugin/incr-0.2.zsh ]; then
    . ~/.zsh/plugin/incr-0.2.zsh
fi

## 補完関数を作るための設定 {{{
# http://www.ayu.ics.keio.ac.jp/~mukai/translate/write_zsh_functions.html
zstyle ':completion:*' verbose yes
#zstyle ':completion:*' format '%BCompleting %d%b'
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# site-functionsのリロード
rsf() {
  local f
  f=(~/local/share/zsh/site-functions/*(.))
  unfunction $f:t 2> /dev/null
  autoload -U $f:t
}
## }}}
# }}}

## 改行でls {{{
## http://d.hatena.ne.jp/kei_q/20110406/1302091565
#alls() {
#  if [[ -z "$BUFFER" ]]; then
#      echo ''
#      ls
#  fi
#  zle accept-line
#}
#zle -N alls
#bindkey "\C-m" alls
#bindkey "\C-j" alls
##}}}

# zmv
# http://ref.layer8.sh/ja/entry/show/id/2694
# http://d.hatena.ne.jp/mollifier/20101227/p1
autoload -Uz zmv
alias zmv='zmv -W'

# 単語境界にならない記号の設定
# /を入れないこと区切り線とみなし、Ctrl+Wで1ディレクトリだけ削除できたりする
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# http://d.hatena.ne.jp/kiririmode/20120327/p1
# add-zsh-hook precmd functionするための設定
autoload -Uz add-zsh-hook

# ディレクトリ関連 {{{
# ==============================================================================
# auto change directory
setopt auto_cd
# 今いるディレクトリを補完候補から外す
# http://qiita.com/items/7916037b1384d253b457
zstyle ':completion:*' ignore-parents parent pwd ..
# シンボリックリンクのディレクトリにcdしたら実際のディレクトリに移る
# setopt chase_links

# auto_pushd {{{
# ------------------------------------------------------------------------------
# auto directory pushd that you can get dirs list by cd -(+)[tab]
# -:古いのが上、+:新しいのが上
setopt auto_pushd
# cd -[tab]とcd +[tab]の役割を逆にする
setopt pushd_minus
# pushdで同じディレクトリを重複してpushしない
setopt pushd_ignore_dups
# 保存するディレクトリスタックの数
DIRSTACKSIZE=10

# ディレクトリスタックをファイルに保存することで端末間で共有したり、ログアウトしても残るようにする {{{
# http://sanrinsha.lolipop.jp/blog/2012/02/%E3%83%87%E3%82%A3%E3%83%AC%E3%82%AF%E3%83%88%E3%83%AA%E3%82%B9%E3%82%BF%E3%83%83%E3%82%AF%E3%82%92%E7%AB%AF%E6%9C%AB%E9%96%93%E3%81%A7%E5%85%B1%E6%9C%89%E3%81%97%E3%81%9F%E3%82%8A%E3%80%81%E4%BF%9D.html
# cdする前に現在のディレクトリを保存
function share_dirs_preexec {
    pwd >> ~/.dirs
}
# プロンプトが表示される前にディレクトリスタックを更新する
function share_dirs_precmd {
    if which tac 1>/dev/null 2>&1;then
        TAC=`which tac`
    else
        TAC='tail -r'
    fi

    # 現在のディレクトリに戻ってこれるように書き込む
    pwd >> ~/.dirs
    # ファイルの書き込まれたディレクトリを移動することでディレクトリスタックを更新
    while read line
    do
        # ディレクトリが削除されていることもあるので調べる
        [ -d $line ] && cd $line
    done <~/.dirs
    # 削除されたディレクトリが取り除かれた新しいdirsを時間の昇順で書き込む
    dirs | tr " " "\n" | sed "s|~|${HOME}|" | eval ${TAC} >! ~/.dirs
}
# autoload -Uz add-zsh-hookが必要
add-zsh-hook preexec share_dirs_preexec
add-zsh-hook precmd  share_dirs_precmd
# }}}
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
## C-sでのヒストリ検索が潰されてしまうため、出力停止・開始用にC-s/C-qを使わない。
setopt no_flow_control
# 対話シェルでコメントを使えるようにする
setopt interactive_comments

## Command history configuration
#
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
## ヒストリファイルにコマンドラインだけではなく実行時刻と実行時間も保存する。
setopt extended_history
## 同じコマンドラインを連続で実行した場合はヒストリに登録しない。
setopt hist_ignore_dups
## スペースで始まるコマンドラインはヒストリに追加しない。
setopt hist_ignore_space
## すぐにヒストリファイルに追記する。
#setopt inc_append_history
# share_historyをしていれば必要ない
# http://www.ayu.ics.keio.ac.jp/~mukai/translate/zshoptions.html#SHARE_HISTORY
## zshプロセス間でヒストリを共有する。
setopt share_history
# }}}

# precmd系 {{{
# =============================================================================
# http://d.hatena.ne.jp/kiririmode/20120327/p1
# add-zsh-hook precmd functionするための設定
autoload -Uz add-zsh-hook

# プロンプト {{{
#==============================================================================
# 改行のない出力をプロンプトで上書きするのを防ぐ
unsetopt promptcr
#setopt print_exit_value
#autoload -Uz colors; colors

#C-zでサスペンドしたとき(18)以外のエラー終了時に(;_;)!を表示
#local err="%0(?||%18(?||%{$fg[red]%}(;_;%)!%{${reset_color}%}"$'\n'"))"


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
    #err="%0(?||%18(?||%{$fg[red]%}(;_;%)!%{${reset_color}%}"$'\n'"))"
    # パスの~の部分の色を反転させる
    #tildepwd=$(pwd | sed "s|$HOME|%S~%s|")
    #PROMPT="${err}${color}[%m:${tildepwd}]%#%{${reset_color}%} "

    #pct="%0(?||%18(?||%{$fg[red]%}))%#%{${reset_color}%}"
    #PROMPT="${color}[%m:%~]${pct} "
}
#add-zsh-hook preexec prompt_preexec
add-zsh-hook precmd prompt_precmd
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

# }}}

# }}}

# tmux {{{
# tmuxでset-window-option -g automatic-rename offが聞かない場合の設定
# http://qiita.com/items/c166700393481cb15e0c
DISABLE_AUTO_TITLE=true
# }}}

if [ -f ~/.zshrc.local ]; then
    . ~/.zshrc.local
fi

if [[ `uname` = CYGWIN* ]]; then
    test -f ~/.zshrc.cygwin && . ~/.zshrc.cygwin
else
    test -f ~/.zshrc.vcs && . ~/.zshrc.vcs
    if [ -f ~/.zsh/plugin/z.sh ]; then
        _Z_CMD=j
        source ~/.zsh/plugin/z.sh
    fi
fi
