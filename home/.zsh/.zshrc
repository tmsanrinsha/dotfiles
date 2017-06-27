#bash, zsh共通設定の読み込み
if [ -f ~/.sh/rc.sh ]; then
    . ~/.sh/rc.sh
fi

if command_exists tac;then
    tac=`which tac`
else
    tac='tail -r'
fi

# path {{{1
# ============================================================================
# 重複パスの除去
# http://d.hatena.ne.jp/yascentur/20111111/1321015289
#LD_LIBRARY_PATH=${HOME}/lib:$LD_LIBRARY_PATH
#INCLUDE=${HOME}/include:$INCLUDE

[ -z "$ld_library_path" ] && typeset -T LD_LIBRARY_PATH ld_library_path
[ -z "$include" ] && typeset -T INCLUDE include
typeset -U path cdpath fpath manpath ld_library_path include

fpath=(
    $ZDOTDIR/functions
    $fpath
)

# zplug {{{1
# ============================================================================
if [ "${ZSH_VERSION%%.*}" -ge 5 ]; then
  source $ZDOTDIR/zplug/zplug.zsh
else
  # [zshの起動が遅いのでなんとかしたい - Qiita](http://qiita.com/vintersnow/items/7343b9bf60ea468a4180)
  # によれば、zprogがcompinitはしてくれているので必要ない
  autoload -U compinit && compinit
fi

# 基本設定 {{{1
# ============================================================================
# ファイルがある場合のリダイレクト(>)の防止。上書きしたい場合は>!を使う
setopt noclobber
# 対話シェルでコメントを使えるようにする
setopt interactive_comments
# 終了ステータスコードを表示する
setopt print_exit_value
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
# bashでも使えるaliaseは ../.sh/alias.sh に記述
alias hgr='history 1 | grep -C 3'

# global alias {{{1
# ============================================================================
alias -g A='| awk'
alias -g C='| column -t'
alias -g G='| grep -i'
alias -g J='| jq .'
alias -g L='| less -R'
alias -g PB='| pbcopy'
alias -g PT='| tee >(pbcopy)'
alias -g P='| peco_with_action'
# Vim: Warning: Input is not from a terminal
# http://hateda.hatenadiary.jp/entry/2012/09/06/000000
# http://superuser.com/questions/336016/invoking-vi-through-find-xargs-breaks-my-terminal-why
alias -g PXV="| peco | xargs bash -c '</dev/tty vim \$@' ignoreme"
alias -g V="| vim - -c 'setlocal buftype=nofile noswapfile | file output'"
alias -g VT='| tovim'
alias -g XV="| xargs bash -c '</dev/tty vim \$@' ignoreme"
alias -g X='| xmllint --format -'
alias -g H='| head'
alias -g T='| tail -f'
alias -g E='| egrep'
alias -g GI='| egrep -i'
# alias -g C="2>&1 | sed -e 's/.*ERR.*/[31m&[0m/' -e 's/.*WARN.*/[33m&[0m/'"
alias -g TGZ='| gzip -dc | tar xf -'

# suffix alias {{{1
# ============================================================================
# [zshの個人的に便利だと思った機能（suffix alias、略語展開） - Qiita](http://qiita.com/matsu_chara/items/8372616f52934c657214)
if [ "$os" = mac ]; then
    alias -s app='open'
    alias -s xpi='open -a Firefox'
fi

# prompt {{{1
# ============================================================================
# 最後に改行のない出力をプロンプトで上書きするのを防ぐ
# unsetopt promptcr
# バージョン4.3.0からはデフォルトでセットされるprompt_spというオプションで
# 最後に改行がない場合は%か#を最後に加えて改行されるようになった。

# 現在のホストによってプロンプトの色を変える。
# 256色の内、カラーで背景黒の時見やすい色はこの216色かな
colArr=({1..6} {9..14} {22..59} {61..186} {190..229})

# hostnameをmd5でハッシュに変更し、1-217の数値を生成する
# hostnameが長いとエラーが出るので最初の8文字を使う
if command_exists md5; then
    md5=md5
else
    md5=md5sum
fi

# 256色番
# host_num=$((0x`hostname | $md5 | cut -c1-8` % 216 + 1)) # zshの配列のインデックスは1から
# user_num=$((0x`whoami   | $md5 | cut -c1-8` % 216 + 1))
#
# host_color="%{"$'\e'"[38;5;$colArr[$host_num]m%}"
# user_color="%{"$'\e'"[38;5;$colArr[$user_num]m%}"
# host_color="%{"$'\e'"[38;5;$colArr[$host_num]m%}"
# user_color="%{"$'\e'"[38;5;$colArr[$user_num]m%}"

host_num=$((0x`hostname | $md5 | cut -c1-8` % 6 + 31)) # 31から赤
user_num=$(((0x`(hostname; whoami) | $md5 | cut -c1-8`) % 6 + 31))
host_color="%{"$'\e'"[${host_num}m%}"
user_color="%{"$'\e'"[${user_num}m%}"

reset_color=$'\e'"[0m"
fg_yellow=$'\e'"[33m"
fg_red=$'\e'"[31m"
fg_white=$'\e'"[37m"
bg_red=$'\e'"[41m"

# リポジトリの情報を表示
test -f $ZDOTDIR/.zshrc.vcs && . $ZDOTDIR/.zshrc.vcs

function _update_prompt() {
  PROMPT="${user_color}%n%{${reset_color}%}@${host_color}%M%{${reset_color}%} %F{blue}%U%D{%Y-%m-%d %H:%M:%S}%u%f"
  PROMPT="$PROMPT $(_update_vcs_info_msg)"
  # jobがあるなら表示。SHLVLが3以上（tmux上でvim開いて:shとか）なら表示
  PROMPT="$PROMPT %(1j| JOBS:%j |)%(3L| SHLVL:%L |)"
  PROMPT="$PROMPT
%{$fg_yellow%}%~%{${reset_color}%}%0(?||%18(?|}|%{$fg_white%}%{$bg_red%}))%(!|#|$)%{${reset_color}%} "
}

add-zsh-hook precmd _update_prompt

# %?: 直前のコマンドの終了ステータスコード
# [zshの設定 - wasabi0522's blog](http://aircastle.hatenablog.com/entry/20080428/1209313162)


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
# complete {{{1
# ============================================================================
# bash用の補完を使うためには以下の設定をする
# https://github.com/dsanson/pandoc-completion
# autoload bashcompinit
# bashcompinit
# source "/path/to/hoge-completion.bash"

# compacked complete list display
setopt list_packed
setopt complete_in_word      # 語の途中でもカーソル位置で補完

# cacheを使う
zstyle ':completion:*' use-cache true

# [zshのzstyleでの補完時の挙動について - voidy21の日記](http://voidy21.hatenablog.jp/entry/20090902/1251918174)
# m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完する。
# r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する。
# r:については挙動がおかしくなるのでやめる
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[._-]=*'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# _expandはグロブを使ったときファイルが補完対象に入るので使わない
# _historyも関係ない文脈で補完されるので使わない
# _matchはファイルパスに空白があるとうまくいかないので使わない
zstyle ':completion:*' completer _complete _prefix _list

# menu complition {{{2
zmodload -i zsh/complist

# tab二回でmenuから選択できるようにする
zstyle ':completion:*:default' menu select=2

# [zshのメニュー補完で候補をインタラクティブに絞り込む - Qiita](http://qiita.com/ToruIwashita/items/5cfa382e9ae2bd0502be)
# zstyle ':completion:*' menu select interactive
# 上のcompleterで_matchを設定しているとグロブが使えるので良い。
# しかしinteractiveを設定するとtabでmenuを選択できなくなるので、やめる

# menuselectのキーバインド
bindkey -M menuselect \
    '^p' up-line-or-history \
    '^n' down-line-or-history \
    '^b' backward-char \
    '^f' forward-char \
    '^o' accept-and-infer-next-history
bindkey -M menuselect "\e[Z" reverse-menu-complete # Shift-Tabで補完メニューを逆に選ぶ
bindkey -M menuselect '^r'   history-incremental-search-forward # 補完候補内インクリメンタルサーチ
bindkey -M menuselect '^s'   history-incremental-search-backward
# bindkey -M menuselect '^i' menu-expand-or-complete # 一回のCtrl+I or Tabで補完メニューの最初の候補を選ぶ
# }}}

# ファイル・ディレクトリ補完に色を付ける
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
else
    zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
fi

# zshのzstyleでの補完時の挙動について - voidy21の日記
# http://voidy21.hatenablog.jp/entry/20090902/1251918174
# カレントディレクトリに候補がないとき、cdpathのディレクトリを候補に出す
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
# cd ../<TAB>のとき、カレントディレクトリを表示させない
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# killで今のシェル以外のプロセスも補完する
zstyle ':completion:*:processes' command "ps -u $USER -o pid,stat,%cpu,%mem,cputime,command"

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

# MacVimでvimの補完を使う
compdef Vim=vim

# Zsh - へルプオプション `--help` を受け付けるコマンドのオプション補完をある程度自動的にしてくれる `_gnu_generic` 関数の使い方です。 - Qiita
# http://qiita.com/hchbaw/items/c1df29fe55b9929e9bef
compdef _gnu_generic bc
# compdef _gnu_generic composer
compdef _gnu_generic phpunit
compdef _gnu_generic phpunit.sh

# zsh + tmux で端末に表示されてる文字列を補完する - Qiita {{{2
# ----------------------------------------------------------------------------
# <http://qiita.com/hamaco/items/4eb19da6cf216104adf0>

dabbrev-complete () {
  local hardcopy buffername reply lines=80

  tmux capture-pane
  # tmuxのバージョンによって違う？
  # hardcopy=$(tmux save-buffer -b 0 -)
  buffername=$(tmux list-buffers | head -1 | cut -d':' -f1)
  hardcopy=$(tmux save-buffer -b $buffername -)
  tmux delete-buffer -b $buffername
  reply=($(
    echo $hardcopy |
    # 空白行の削除
    sed '/^$/d' |
    # 最後の2行（プロンプト行と補完候補行が一行と仮定）は消す
    sed '$d' | sed '$d' |
    # いらない文字を空白に変換
    sed 's/[<>]/ /g' |
    # 最後の$lines行だけ取得
    tail -$lines
  ))

  # 文字列の最後の*/=@|については削除
  compadd -Q - "${reply[@]%[*/=@|]}"
}

zle -C dabbrev-complete complete-word dabbrev-complete
bindkey '^o' dabbrev-complete

# file completion {{{2
# ----------------------------------------------------------------------------
complete_files () {
    compadd - $PREFIX*
}
zle -C complete-files complete-word complete_files
bindkey '^x^f' complete-files

# gcloud {{{2
# ----------------------------------------------------------------------------
# The next line updates PATH for the Google Cloud SDK.
# if [ -f $HOME/google-cloud-sdk/path.zsh.inc ]; then
#   source "$HOME/google-cloud-sdk/path.zsh.inc"
# fi

# kubectl.zshが^Xeを上書きしているので注意
# (N)はグロブにマッチしなくてもエラーを出さないオプション
# for file in $ZDOTDIR/completion/*.zsh(N); do
#     source $file
# done

# Incremental completion on zsh {{{2
# ----------------------------------------------------------------------------
# http://mimosa-pudica.net/zsh-incremental.html
# if [ -f ~/.zsh/plugin/incr-0.2.zsh ]; then
#     . ~/.zsh/plugin/incr-0.2.zsh
# fi

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

bindkey '^[' vi-cmd-mode

# Key待ちを10ミリ秒にする
# http://zsh.sourceforge.net/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell-1
KEYTIMEOUT=1

# bindkey '^]'  vi-find-next-char
# bindkey '^[]' vi-find-prev-char

# ^sでロックしない
# [「Ctrl」＋「S」でキー入力が受け付けられなくなる - ITmedia エンタープライズ](http://www.itmedia.co.jp/help/tips/linux/l0612.html)
stty stop undef

# コマンドラインをeditorで編集する
# ----------------------------------------------------------------------------
# [zshのコマンドラインを任意のテキストエディタで編集する - Qiita](http://qiita.com/mollifier/items/7b1cfe609a7911a69706)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^xv' edit-command-line

# M-.を賢くする {{{2
# ----------------------------------------------------------------------------
# zshで直前のコマンドラインの最後の単語を挿入する
# http://qiita.com/mollifier/items/1a9126b2200bcbaf515f
autoload -Uz smart-insert-last-word
# [a-zA-Z], /, \ のうち少なくとも1文字を含む長さ2以上の単語
zstyle :insert-last-word match '*([[:alpha:]/\\]?|?[[:alpha:]/\\])*'
zle -N insert-last-word smart-insert-last-word

# 前方一致ヒストリ履歴検索 {{{2
# ----------------------------------------------------------------------------
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

# incremental search {{{2
# ----------------------------------------------------------------------------
# |peco| も参照
# グロブ(*)が使えるインクリメンタルサーチ
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
## C-sでのヒストリ検索が潰されてしまうため、出力停止・開始用にC-s/C-qを使わない。
setopt no_flow_control

# C-w {{{2
# ----------------------------------------------------------------------------
# 単語を構成する文字とみなす記号の設定
# /を入れないことでを単語境界とみなし、Ctrl+Wで1ディレクトリだけ削除できるようにする
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# kill-region, copy-region {{{2
# ----------------------------------------------------------------------------
# zshで範囲選択・削除・コピー・切り取りする - Qiita
# http://qiita.com/takc923/items/35d9fe81f61436c867a8
## 範囲削除
function delete-region() {
    zle kill-region
    CUTBUFFER=$killring[1]
    shift killring
}
zle -N delete-region

function backward-delete-char-or-region() {
    if [ $REGION_ACTIVE -eq 0 ]; then
        zle backward-delete-char
    else
        zle delete-region
    fi
}
zle -N backward-delete-char-or-region

function delete-char-or-list-or-region() {
    if [ $REGION_ACTIVE -eq 0 ]; then
        zle delete-char-or-list
    else
        zle delete-region
    fi
}
zle -N delete-char-or-list-or-region

bindkey "^h" backward-delete-char-or-region
bindkey "^d" delete-char-or-list-or-region

## 範囲コピー
function copy-region() {
    zle copy-region-as-kill
    REGION_ACTIVE=0
}
zle -N copy-region
bindkey "^[w" copy-region

## 範囲切り取り
function backward-kill-word-or-region() {
    if [ $REGION_ACTIVE -eq 0 ]; then
        zle backward-kill-word
    else
        zle kill-region
    fi
}
zle -N backward-kill-word-or-region
bindkey "^w" backward-kill-word-or-region

# C-z, fg {{{2
# ----------------------------------------------------------------------------
# ctrl-zでfgする
# [Vimの生産性を高める12の方法 | 開発手法・プロジェクト管理 | POSTD](http://postd.cc/how-to-boost-your-vim-productivity/)
fancy-ctrl-z () {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line
    else
        zle push-input
        zle clear-screen
    fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# ^[c でpbcopy {{{2
# ----------------------------------------------------------------------------
pbcopy-buffer() {
    echo -n "$BUFFER" | pbcopy
    BUFFER=''
}
zle -N pbcopy-buffer
bindkey "^[c" pbcopy-buffer

# C-^でcdr {{{2
# ----------------------------------------------------------------------------
cdr-ctrl-^ () {
    BUFFER=cdr
    zle accept-line
}
zle -N cdr-ctrl-^
bindkey '^^' cdr-ctrl-^

# ディレクトリ関連 {{{1
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
    if command_exists tac;then
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
# cdr {{{2
# ----------------------------------------------------------------------------
# zshでcdの履歴管理に標準添付のcdrを使う - @znz blog http://blog.n-z.jp/blog/2013-11-12-zsh-cdr.html
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    # zstyle ':completion:*:*:cdr:*:*' menu selection
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$ZDOTDIR/.cache/chpwd-recent-dirs"
    # zstyle ':chpwd:*' recent-dirs-pushd true
fi
# }}}
# history {{{1
# =============================================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# ヒストリファイルにコマンドラインだけではなく実行時刻と実行時間も保存する。
setopt extended_history
# 同じコマンドラインを連続で実行した場合はヒストリに登録しない。
setopt hist_ignore_dups
# スペースで始まるコマンドラインはヒストリに追加しない。
setopt hist_ignore_space
# 余分な空白は詰めて記録
setopt nohist_reduce_blanks
# zshプロセス間でヒストリを共有する。
setopt share_history
# # すぐにヒストリファイルに追記する。
# setopt inc_append_history
# share_historyをしていれば必要ない
# http://www.ayu.ics.keio.ac.jp/~mukai/translate/zshoptions.html#SHARE_HISTORY

# 端末のタイトルを変更する title {{{1
# ============================================================================
# [My Future Sight for Past: Dynamic terminal title on bash, zsh, tmux](http://myfuturesightforpast.blogspot.jp/2015/10/dynamic-terminal-title-on-bash-zsh-tmux.html)
# \e]2の部分は0,1,2で変更する部分が変わる
# 0: ウィンドウタイトル+アイコン名
# 1: アイコン名
# 2: ウィンドウタイトル
# アイコン名はwindowsだと昔あったタスクバーの名前に相当
#   参照: [gnome terminal - In xterm, what is "Icon Name"? - Unix & Linux Stack Exchange](http://unix.stackexchange.com/questions/234136/in-xterm-what-is-icon-name)
# iTerm2だとタブ名
set_terminal_title_string() {
  local title=${PWD/$HOME/"~"}@${HOST%%.*}

  if [[ "${TERM}" =~ kterm\|xterm\|screen ]]; then
    echo -ne "\e]0;$title\007"
  fi

  # [$PWD in window title bar, both in Bash and Tmux - Stack Overflow](http://stackoverflow.com/questions/21607282/pwd-in-window-title-bar-both-in-bash-and-tmux)
  # によれば ~/.tmux.confに
  # set -g set-titles on
  # set -g set-titles-string '#T' (#Tはpane_title)
  # をつけるとtmux起動時にも端末のタイトルを変更することができる。
  # この場合タイトルはpaneごとに保持される
  #
  # set-titles [on | off]
  #         Attempt to set the client terminal title using the tsl and fsl terminfo(5) entries if they exist.  tmux automatically sets these to the
  #         \e]0;...\007 sequence if the terminal appears to be xterm(1).  This option is off by default.
  #
  # set-titles-string string
  #         String used to set the window title if set-titles is on.  Formats are expanded, see the FORMATS section.
  #
  # \e]0;...\007なので、ウィンドウとアイコンの両方。ここも設定できるとよいのだが。

  # 以下のようにパススルーシーケンスでやるとpaneごとに保持されない
  # echo -ne "\ePtmux;\e\e]2;$title\007\e\\"
}

add-zsh-hook precmd set_terminal_title_string
add-zsh-hook preexec set_terminal_title_string

# Tmuxのウィンドウ名をコマンド実行時はコマンド名@ホスト名それ以外は@ホスト名にする {{{1
# ============================================================================
if [[ $TERM =~ screen ]]; then
  function tmux_preexec() {
    # mycmd=(${(s: :)${1}})
    # コマンドの名のみ
    echo -ne "\ek${1%% *}@${HOST%%.*}\e\\"
  }

  function tmux_precmd() {
    # サブドメインのみ
    echo -ne "\ek@${HOST%%.*}\e\\"
  }
  add-zsh-hook preexec tmux_preexec
  add-zsh-hook precmd  tmux_precmd
  # tmuxでset-window-option -g automatic-rename offが聞かない場合の設定
  # http://qiita.com/items/c166700393481cb15e0c
  DISABLE_AUTO_TITLE=true
fi

# iTerm2のタブのタイトルを変える {{{1
# ============================================================================
# https://iterm2.com/faq.html Q: How do I change a tab's title?
# echo -e "\033];MY_NEW_TITLE\007"

# 通知 {{{1
# ============================================================================
# [FAQ - iTerm2 - Mac OS Terminal Replacement](https://iterm2.com/faq.html)
# Q: How do I use Growl with iTerm2? のリンク先を見ると
#   echo $'\e]9;Growl Notification\007'
# の様に制御シーケンスでいけるらしい。ただしGrowlは有料
#
# [iTerm2 + zshで時間のかかる処理が終わったらGrowlに通知したりアラートダイアログ出したり音出したりする方法 - Qiita](http://qiita.com/takc923/items/75d67a08edfbaa5fd304)
# こちらはiTerm2のtriggerを利用した方法
# x秒以上たったら処理時間を表示
REPORTTIME=10
# TIMEFMTで出力フォーマットを変更可能。see. man zshparam
#
# [Macで時間のかかるコマンドが終わったら、自動で通知するzsh設定 - Qiita](http://qiita.com/kei_s/items/96ee6929013f587b5878)
# backgroundの判定など参考になるかも

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

# peco                                                             *peco* {{{1
# ============================================================================
if hash peco 2>/dev/null; then
    # バッファ上のコマンドを実行して、pecoの選択結果をバッファに出力
    function peco-buffer() {
        BUFFER=" $(eval ${BUFFER} | peco)"
        CURSOR=0
    }
    zle -N peco-buffer
    bindkey "^[p" peco-buffer

    # git {{{2
    # ------------------------------------------------------------------------
    function peco_git_hash() {
        GIT_COMMIT_HASH=$(git log --oneline --graph --all --decorate | peco | sed -e "s/^\W\+\([0-9A-Fa-f]\+\).*$/\1/")
        BUFFER=${BUFFER}${GIT_COMMIT_HASH}
        CURSOR=$#BUFFER
    }
    zle -N peco_git_hash
    bindkey "^xpH" peco_git_hash

    # kill {{{2
    # ------------------------------------------------------------------------
    function peco_kill() {
        ps aux | peco | awk '{ print $2 }' | xargs kill
    }
    alias pk=peco_kill

    # history {{{2
    # ------------------------------------------------------------------------
    function peco-select-history() {
        # historyを番号なし、逆順、最初から表示。
        # 順番を保持して重複を削除。
        # カーソルに左側の文字列をクエリにしてpecoを起動
        # \nを改行に変換
        BUFFER="$(history -nr 1 | awk '!a[$0]++' | peco --query "$LBUFFER" | sed 's/\\n/\n/g')"
        # perl -ne 'print if!$line{$_}++'
        # # historyを番号なし、逆順、時間表示で最初から表示
        # BUFFER=$(history -nri 1 | peco --query "$LBUFFER" | cut -d ' ' -f 4-)
        CURSOR=$#BUFFER             # カーソルを文末に移動
        zle -R -c                   # refresh
    }
    zle -N peco-select-history
    bindkey '^R' peco-select-history

    # hostname {{{2
    # ------------------------------------------------------------------------
    function _get_hosts() {
        # historyを番号なし、逆順、ssh*にマッチするものを1番目から表示
        # 最後の項をhost名と仮定してhost部分を取り出す
        # 改行がはいっているとlocal宣言と代入を一緒にできない？
        local hosts
        ssh_hist="$(history -nrm 'ssh*' 1 | \grep 'ssh ')"
        # hosts="$(echo $ssh_hist | sed 's/ssh\(\s\+-\([1246AaCfGgKkMNnqsTtVvXxYy]\|[^1246AaCfGgKkMNnqsTtVvXxYy]\s\+\S\+\)\)*\s\+\(\S\+@\)\?//' | cut -d' ' -f1)"
        hosts="$(echo $ssh_hist | perl -pe 's/ssh(\s+-([1246AaCfGgKkMNnqsTtVvXxYy]|[^1246AaCfGgKkMNnqsTtVvXxYy]\s+\S+))*\s+(\S+@)?//' | cut -d' ' -f1)"
        #                                   ------------------------------------------------------------------------------ ------
        #                                                        hostnameよりも前にあるオプション                          user@  を削除
        # know_hostsからもホスト名を取り出す
        # portを指定したり、id指定でsshしていると
        #   [hoge.com]:2222,[\d{3}.\d{3].\d{3}.\d{3}]:2222
        # といったものもあるのでそれにも対応している
        hosts="$hosts\n$(cut -d' ' -f1  ~/.ssh/known_hosts | tr -d '[]' | tr ',' '\n' | cut -d: -f1)"
        hosts=$(echo $hosts | awk '!a[$0]++')
        echo $hosts
    }

    function peco-ssh() {
        hosts=`_get_hosts`
        local selected_host=$(echo $hosts | peco --prompt="ssh>" --query "$LBUFFER")
        if [ -n "$selected_host" ]; then
            BUFFER="ssh ${selected_host}"
            zle accept-line
        fi
    }
    zle -N peco-ssh
    bindkey '^[s' peco-ssh

    function peco-host() {
      hosts=`_get_hosts`
      local selected_host=$(echo $hosts | peco --prompt="host>")
      local rbuffer_num=$#RBUFFER
      if [ -n "$selected_host" ]; then
        BUFFER="$LBUFFER${selected_host}$RBUFFER"
        CURSOR=$(($#BUFFER - $rbuffer_num))
      fi
    }
    zle -N peco-host
    bindkey '^[S' peco-host

    # cdr {{{2
    function peco-cdr () {
        local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr>" --query "$LBUFFER")"
        if [ -n "$selected_dir" ]; then
            BUFFER="cd ${selected_dir}"
            zle accept-line
        fi
    }
    zle -N peco-cdr
    bindkey '^[r' peco-cdr

    # fd {{{2
    # ------------------------------------------------------------------------
    function fd () {
        local find_result selected_dir
        find_result="$(find . -type d -mindepth 1 \( -name '.svn' -o -name '.git' -o -name 'vendor' \) -prune -o -type d -name "*$1*" -print | sed 's@./@@')"

        if [ -z $find_result ]; then
            return 1
        fi

        if [ $(echo $find_result | wc -l) -eq 1 ]; then
            echo ${find_result}
            pwd
            cd ${find_result}
            return
        fi

        selected_dir="$(echo $find_result | peco --prompt="fd>" --query "$1")"
        if [ -n "$selected_dir" ]; then
            cd ${selected_dir}
        fi
    }

    # ghq {{{2
    # ------------------------------------------------------------------------
    function peco-ghq-cd () {
      # Gitリポジトリを.gitの更新時間でソートする
      local selected_dir=$(ghq-list.sh | peco --prompt="cd-ghq>" --query "$LBUFFER")
      if [ -n "$selected_dir" ]; then
        BUFFER="cd $(ghq list --full-path | grep -E "/$selected_dir$")"
        zle accept-line
      fi
    }
    zle -N peco-ghq-cd
    bindkey '^[g' peco-ghq-cd

    function peco-ghq () {
        local selected_dir=$(ghq-list.sh| peco --prompt="ghq>")
        local rbuffer_num=$#RBUFFER
        if [ -n "$selected_dir" ]; then
          BUFFER="${LBUFFER}$(ghq list --full-path | grep -E "/$selected_dir$")${RBUFFER}"
          CURSOR=$(($#BUFFER - $rbuffer_num))
        fi
    }
    zle -N peco-ghq
    bindkey '^[G' peco-ghq

    # grepしてvimで開く {{{2
    # ------------------------------------------------------------------------
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

    function peco_with_action {
        local selected action
        peco | selected=`cat -` </dev/tty
        if [ -z "$selected" ]; then
            return
        fi
        echo -n "command: "
        read action </dev/tty
        echo $ $action ${selected/$'\n'/ }
        eval $action ${selected/$'\n'/ } </dev/tty
    }
    # }}}
fi

# Vim {{{1
# ============================================================================
# [vimrc のどこが重いのかを調べるもう1つの方法 - 永遠に未完成](http://thinca.hatenablog.com/entry/20120316/1331836420)
function vim-profile() {
  local profile=~/tmp/vim_profile
  test -f $profile && \rm $profile
  vim --startuptime $profile +q
  vim $profile
  # :sort f /^.\{18\}\zs./
}

function vim-profile-vimrc() {
  local profile=~/tmp/vim_profile_vimrc
  test -f $profile && \rm $profile
  vim --cmd "profile start $profile" --cmd "profile file $HOME/.vim/vimrc" +q
  vim $profile
}
# }}}

# if [ -f $ZDOTDIR/plugin/z.sh ]; then
#     _Z_CMD=j
#     source $ZDOTDIR/plugin/z.sh
# fi

if [ -f $ZDOTDIR/.zshrc.cache ]; then
    source $ZDOTDIR/.zshrc.cache
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

if [[ "$PROFILE_STARTUP" == true ]]; then
  unsetopt xtrace
  exec 2>&3 3>&-
fi
