#bash, zsh共通設定の読み込み
if [ -f ~/.zashrc ]; then
    . ~/.zashrc
fi

# antigen {{{1
# ============================================================================
# antigenをsubtreeで管理には以下のコマンド
# antigenをリモートリポジトリに登録する
#   git remote add -f antigen https://github.com/zsh-users/antigen
# subtrees/antigenというディレクトリで管理するするにはリポジトリのルートディレクトリで
#   git subtree add --prefix=subtrees/antigen antigen master --squash

# source $SRC_ROOT/tmsanrinsha/dotfiles/subtrees/antigen/antigen.zsh
# antigen bundle zsh-users/zsh-completions src
# # 自動アップデート
# ANTIGEN_SYSTEM_RECEIPT_F='.zsh/.cache/antigen_system_lastupdate'
# ANTIGEN_PLUGIN_RECEIPT_F='.zsh/.cache/antigen_plugin_lastupdate'
# antigen bundle unixorn/autoupdate-antigen.zshplugin

# Tell antigen that you're done.
# antigen apply

# path {{{1
# ============================================================================
# 重複パスの除去
# http://d.hatena.ne.jp/yascentur/20111111/1321015289
#LD_LIBRARY_PATH=${HOME}/lib:$LD_LIBRARY_PATH
#INCLUDE=${HOME}/include:$INCLUDE

[ -z "$ld_library_path" ] && typeset -T LD_LIBRARY_PATH ld_library_path
[ -z "$include" ] && typeset -T INCLUDE include
typeset -U path cdpath fpath manpath ld_library_path include

fpath=(~/.zsh/functions ~/.zsh/completions ~/.zsh/zsh-users-slash-zsh-completions $fpath)
# ghqの補完
# fpath=($GOPATH/src/github.com/motemen/ghq/zsh(N) $fpath)

# 基本設定 {{{1
# ============================================================================
# ファイルがある場合のリダイレクト(>)の防止したい場合は>!を使う
setopt noclobber

# 対話シェルでコメントを使えるようにする
setopt interactive_comments
# zmv
# http://ref.layer8.sh/ja/entry/show/id/2694
# http://d.hatena.ne.jp/mollifier/20101227/p1
autoload -Uz zmv
alias zmv='zmv -W'
# add-zsh-hook precmd functionするための設定
# http://d.hatena.ne.jp/kiririmode/20120327/p1
autoload -Uz add-zsh-hook

# alias {{{1
# ============================================================================
alias hgr='history 1 | grep -C 3'

# global alias {{{1
# ============================================================================
alias -g A='| awk'
alias -g G='| grep'
alias -g L='| less -R'
alias -g P='| peco'
# Vim: Warning: Input is not from a terminal
# http://hateda.hatenadiary.jp/entry/2012/09/06/000000
# http://superuser.com/questions/336016/invoking-vi-through-find-xargs-breaks-my-terminal-why
alias -g PXV="| peco | xargs bash -c '</dev/tty vim \$@' ignoreme"
alias -g V='| vim -R -'
alias -g XV="| xargs bash -c '</dev/tty vim \$@' ignoreme"
alias -g H='| head'
alias -g T='| tail -f'
alias -g R='| tail -r'
alias -g E='| egrep'
alias -g GI='| egrep -i'
alias -g X='-print0 | xargs -0'
alias -g C="2>&1 | sed -e 's/.*ERR.*/[31m&[0m/' -e 's/.*WARN.*/[33m&[0m/'"
alias -g TGZ='| gzip -dc | tar xf -'
# }}}
# prompt {{{
# ==============================================================================
# 最後に改行のない出力をプロンプトで上書きするのを防ぐ
# unsetopt promptcr
# バージョン4.3.0からはデフォルトでセットされるprompt_spというオプションで
# 最後に改行がない場合は%か#を最後に加えて改行されるようになった。

# 現在のホストによってプロンプトの色を変える。
# 256色の内、カラーで背景黒の時見やすい色はこの216色かな
colArr=({1..6} {9..14} {22..59} {61..186} {190..229})

# hostnameをmd5でハッシュに変更し、1-217の数値を生成する
# hostnameが長いとエラーが出るので最初の8文字を使う
if which md5 1>/dev/null 2>&1; then
    md5=md5
else
    md5=md5sum
fi
host_num=$((0x`hostname | $md5 | cut -c1-8` % 216 + 1)) # zshの配列のインデックスは1から
user_num=$((0x`whoami   | $md5 | cut -c1-8` % 216 + 1))

host_color="%{"$'\e'"[38;5;$colArr[$host_num]m%}"
user_color="%{"$'\e'"[38;5;$colArr[$user_num]m%}"

reset_color=$'\e'"[0m"
fg_yellow=$'\e'"[33m"
fg_red=$'\e'"[31m"
bg_red=$'\e'"[41m"

PROMPT="${user_color}%n%{${reset_color}%}@${host_color}%M%{${reset_color}%} %F{blue}%U%D{%Y-%m-%d %H:%M:%S}%u%f
%0(?|%{$fg_yellow%}|%18(?|%{$fg_yellow%}|%{$bg_red%}))%~%(!|#|$)%{${reset_color}%} "
# リポジトリの情報を表示
test -f $ZDOTDIR/.zshrc.vcs && . $ZDOTDIR/.zshrc.vcs

PROMPT2="%_> "

# コマンド実行時に右プロンプトをけす
# setopt transient_rprompt

# command correct edition before each completion attempt
setopt correct
SPROMPT="%{$fg_yellow%}%r is correct? [n,y,a,e]:%{${reset_color}%} "

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
# keybind {{{1
# ============================================================================
bindkey -e # emacs like
# bindkey -v # vi like
bindkey "^/" undo
bindkey "^[/" redo
bindkey "^[v" quoted-insert
# DELで一文字削除
bindkey "^[[3~" delete-char
# HOMEで行頭へ
bindkey "^[[1~" beginning-of-line
# Endで行末へ
bindkey "^[[4~" end-of-line

bindkey '^]'  vi-find-next-char
bindkey '^[]' vi-find-prev-char

# zshで直前のコマンドラインの最後の単語を挿入する
# http://qiita.com/mollifier/items/1a9126b2200bcbaf515f
autoload -Uz smart-insert-last-word
# [a-zA-Z], /, \ のうち少なくとも1文字を含む長さ2以上の単語
zstyle :insert-last-word match '*([[:alpha:]/\\]?|?[[:alpha:]/\\])*'
zle -N insert-last-word smart-insert-last-word
# bindkey '^]' insert-last-word

# 前方一致ヒストリ履歴検索
bindkey "^N" history-beginning-search-forward
bindkey "^P" history-beginning-search-backward

# カーソル位置が行末になったほうがいい人の設定
# 漢のzsh (4) コマンド履歴の検索～EmacsとVi、どっちも設定できるぜzsh <http://news.mynavi.jp/column/zsh/004/>
# autoload history-search-end
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
# history-beginning-search-backward-end
# history-beginning-search-forward-end

# 2行以上あるとき、^p,^nで上下にしたいときは以下の設定。
# ただし、ヒストリ検索のときカーソルが行末になる
# autoload -U up-line-or-beginning-search down-line-or-beginning-search 
# zle -N up-line-or-beginning-search
# zle -N down-line-or-beginning-search
# bindkey "^P" up-line-or-beginning-search
# bindkey "^N" down-line-or-beginning-search
# Zsh - コード片置き場 <https://sites.google.com/site/codehen/environment/zsh>

# グロブ(*)が使えるインクリメンタルサーチ
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
## C-sでのヒストリ検索が潰されてしまうため、出力停止・開始用にC-s/C-qを使わない。
setopt no_flow_control

# 単語境界とみなさない記号の設定
# /を入れないことでを単語境界とみなし、Ctrl+Wで1ディレクトリだけ削除できるようにする
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# menuselectのキーバインド
zmodload -i zsh/complist
bindkey -M menuselect \
    '^p' up-line-or-history '^n' down-line-or-history \
    '^b' backward-char '^f' forward-char \
    '^o' accept-and-infer-next-history
bindkey -M menuselect "\e[Z" reverse-menu-complete # Shift-Tabで補完メニューを逆に選ぶ
# bindkey -M menuselect '^i' menu-expand-or-complete # 一回のCtrl+I or Tabで補完メニューの最初の候補を選ぶ
# }}}
# complete {{{
# ============================================================================
autoload -U compinit && compinit
# bash用の補完を使うためには以下の設定をする
# https://github.com/dsanson/pandoc-completion
# autoload bashcompinit
# bashcompinit
# source "/path/to/hoge-completion.bash"

# compacked complete list display
setopt list_packed

if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
else
    zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
fi

# 今いるディレクトリを補完候補から外す
# http://qiita.com/items/7916037b1384d253b457
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*' use-cache true
# 補完対象が2つ以上の時、選択できるようにする
zstyle ':completion:*:default' menu select=2

## 補完関数を作るための設定
# http://www.ayu.ics.keio.ac.jp/~mukai/translate/write_zsh_functions.html
zstyle ':completion:*' verbose yes
#zstyle ':completion:*' format '%BCompleting %d%b'
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# コンテキストの確認
bindkey "^Xh" _complete_help

# site-functionsのリロード
rsf() {
  local f
  f=(~/local/share/zsh/site-functions/*(.))
  unfunction $f:t 2> /dev/null
  autoload -U $f:t
}

# Incremental completion on zsh
# http://mimosa-pudica.net/zsh-incremental.html
if [ -f ~/.zsh/plugin/incr-0.2.zsh ]; then
    . ~/.zsh/plugin/incr-0.2.zsh
fi

# ディレクトリ関連 {{{
# ==============================================================================
# auto change directory
setopt auto_cd
# シンボリックリンクのディレクトリにcdしたら実際のディレクトリに移る
# setopt chase_links

# directory stack {{{
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

## ディレクトリスタックをファイルに保存することで端末間で共有したり、ログアウトしても残るようにする {{{
# http://sanrinsha.lolipop.jp/blog/2012/02/%E3%83%87%E3%82%A3%E3%83%AC%E3%82%AF%E3%83%88%E3%83%AA%E3%82%B9%E3%82%BF%E3%83%83%E3%82%AF%E3%82%92%E7%AB%AF%E6%9C%AB%E9%96%93%E3%81%A7%E5%85%B1%E6%9C%89%E3%81%97%E3%81%9F%E3%82%8A%E3%80%81%E4%BF%9D.html
test ! -d ~/.zsh && mkdir ~/.zsh
test ! -f ~/.zsh/.dirstack && touch ~/.zsh/.dirstack
# プロンプトが表示される前にディレクトリスタックを更新する
function share_dirs_precmd {
    if which tac 1>/dev/null 2>&1;then
        taccmd=`which tac`
    else
        taccmd='tail -r'
    fi

    pwd >> ~/.zsh/.dirstack
    # ファイルの書き込まれたディレクトリを移動することでディレクトリスタックを更新
    while read line
    do
        # ディレクトリが削除されていることもあるので調べる
        [ -d $line ] && cd $line
    done < ~/.zsh/.dirstack
    # 削除されたディレクトリが取り除かれた新しいdirsを時間の昇順で書き込む
    dirs -v | awk '{print $2}' | sed "s|~|${HOME}|" | eval ${taccmd} >! ~/.zsh/.dirstack
}
# ファイルサーバーに接続している環境だと遅くなるので設定しない
if [[ `uname` != Darwin ]]; then
    # autoload -Uz add-zsh-hookが必要
    add-zsh-hook precmd  share_dirs_precmd
fi
# }}} }}}
# cdr
# ----------------------------------------------------------------------------
# zshでcdの履歴管理に標準添付のcdrを使う - @znz blog <http://blog.n-z.jp/blog/2013-11-12-zsh-cdr.html>
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    # zstyle ':completion:*:*:cdr:*:*' menu selection
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 50
    zstyle ':chpwd:*' recent-dirs-file "${ZDOTDIR}/.cache/chpwd-recent-dirs"
    # zstyle ':chpwd:*' recent-dirs-pushd true
fi
# }}}
# 履歴 {{{
# =============================================================================
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
# set terminal title including current directory {{{1
#==============================================================================
set_terminal_title_string() {
    case "${TERM}" in
        kterm*|xterm)
            echo -ne "\e]2;${HOST%%.*}:${PWD}\007"
            ;;
        screen*|xterm-256color) # tmux用
            echo -ne "\ePtmux;\e\e]2;${HOST%%.*}:${PWD}\007\e\\"
            ;;
    esac
}
add-zsh-hook precmd set_terminal_title_string

# tmux & screen {{{1
# ============================================================================
if [ $TERM = screen ];then
# ウィンドウ名をコマンド実行時はコマンド名@ホスト名それ以外はディレクトリ名@ホスト名にする {{{2
# ----------------------------------------------------------------------------
    function tmux_preexec() {
        mycmd=(${(s: :)${1}})
        echo -ne "\ek${1%% *}@${HOST%%.*}\e\\"
    }

    function tmux_precmd() {
        echo -ne "\ek$(basename "$(pwd)")@${HOST%%.*}\e\\"
    }
    add-zsh-hook preexec tmux_preexec
    add-zsh-hook precmd  tmux_precmd
    # tmuxでset-window-option -g automatic-rename offが聞かない場合の設定
    # http://qiita.com/items/c166700393481cb15e0c
    DISABLE_AUTO_TITLE=true

# ssh先でウィンドウ分割・生成した時にssh先に接続する {{{2
# ----------------------------------------------------------------------------
    if hash tmux 2>/dev/null; then
        function tmux_ssh_preexec() {
            local command=$1
            if [[ "$command" = *ssh* ]]; then
                tmux setenv TMUX_SSH_CMD_$(tmux display -p "#I") $command
            fi
        }
        add-zsh-hook preexec tmux_ssh_preexec
    fi
fi

# 改行でls {{{1
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

# peco {{{1
# ============================================================================
if hash peco 2>/dev/null; then
    # git {{{2
    function peco_git_sha1() {
        GIT_COMMIT_HASH=$(git log --oneline --graph --all --decorate | peco | sed -e "s/^\W\+\([0-9A-Fa-f]\+\).*$/\1/")
        BUFFER=${BUFFER}${GIT_COMMIT_HASH}
        CURSOR=$#BUFFER
    }
    zle -N peco_git_sha1
    bindkey "^[s" peco_git_sha1

    # history {{{2
    function peco_select_history() {
        # historyを番号なし、逆順、時間表示で最初から表示
        BUFFER=$(history -nri 1 | peco --query "$LBUFFER" | cut -d ' ' -f 4-)
        CURSOR=$#BUFFER             # move cursor
        zle -R -c                   # refresh
    }
    zle -N peco_select_history
    bindkey '^R' peco_select_history

    # host {{{2
    function peco_select_host() {
        # perl部分は順番を保持して重複を削除 http://keiroku.g.hatena.ne.jp/nnga/20110909/1315571775
        BUFFER=${BUFFER}$(history -nrm 'ssh*' 1 | perl -ne 'print if!$line{$_}++' | awk '{print $2}' | peco)
        CURSOR=$#BUFFER             # move cursor
        zle -R -c                   # refresh
    }
    zle -N peco_select_host
    bindkey '^x^h' peco_select_host

    # cdr {{{2
    function peco-cdr () {
        local selected_dir=$(cdr -l | awk '{ print $2 }' | peco --prompt="cdr > ")
        if [ -n "$selected_dir" ]; then
            BUFFER="cd ${selected_dir}"
            zle accept-line
        fi
        zle clear-screen
    }
    zle -N peco-cdr
    bindkey '^[r' peco-cdr

    # grepしてvimで開く {{{2
    function peco-grep-vim () {
        local selected_result="$(grep -nHr $@ . | peco --query "$@" | awk -F : '{print "-c " $2 " " $1}')"
        if [ -n "$selected_result" ]; then
            eval vim $selected_result
        fi
    }
    alias pgv=peco-grep-vim

    # p {{{2
    # pecoの出力結果に対してコマンド実行
    # http://r7kamura.github.io/2014/06/21/ghq.html
    function p() {
        peco | while read LINE; do $@ $LINE; done
    }
    # }}}
fi
# }}}

if [ -f $ZDOTDIR/plugin/z.sh ]; then
    _Z_CMD=j
    source $ZDOTDIR/plugin/z.sh
fi

if [ -f $ZDOTDIR/.zshrc.local ]; then
    . $ZDOTDIR/.zshrc.local
fi

if [[ `uname` = CYGWIN* ]]; then
    test -f $ZDOTDIR/.zshrc.cygwin && . $ZDOTDIR/.zshrc.cygwin
fi

alias | awk '{print "alias "$0}' \
    | grep -v 'ls --color' \
    | grep -v 'ls -G' \
    | grep -v 'vi=vim' >! ~/.vim/rc/.vimshrc
