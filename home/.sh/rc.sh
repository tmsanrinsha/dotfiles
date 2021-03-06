# bash, zsh共通設定

# .sh/env.shに設定するとDirDiff.vimでのLANG設定(https://github.com/tmsanrinsha/DirDiff.vim/commit/84f11927ae9a915cd7a0d330a1abba26a9982e32)を上書きしてしまうのでここに書く
# 以下のようなエラーが出る場合は
#   perl: warning: Setting locale failed.
#   perl: warning: Please check that your locale settings:
#           LANGUAGE = "en_US:",
#           LC_ALL = (unset),
#           LANG = "ja_JP.UTF-8"
#       are supported and installed on your system.
#   perl: warning: Falling back to the standard locale ("C").
# Ubuntuなら
#   sudo locale-gen ja_JP.UTF-8
# する
export LANG='ja_JP.UTF-8'

# alias {{{1
# ============================================================================
. ~/.sh/alias.sh
# すでにあるコマンドと同名のaliasの設定はここに書いて、
# shell scriptなどでaliasが実行されないようにする
if ls --version | grep GNU 1>/dev/null 2>&1; then
    alias ls='ls --color=auto -F'
    if [ -f ~/.config/dircolors ]; then
        if type dircolors > /dev/null 2>&1; then
            eval $(dircolors ~/.config/dircolors)
        elif type gdircolors > /dev/null 2>&1; then
            eval $(gdircolors ~/.config/dircolors)
        fi
    fi
else
    export LSCOLORS=exfxcxdxbxegedabagacad
    alias ls='ls -G -F'
fi
alias cp='cp -ip'
alias mv='mv -i'
if command_exists rmtrash; then
    alias rm=rmtrash
fi

alias diffl='\diff --old-line-format="%L" --unchanged-line-format="" --new-line-format=""'
alias diffr='\diff --old-line-format="" --unchanged-line-format="" --new-line-format="%L"'
alias diffc='\diff --old-line-format="" --unchanged-line-format="%L" --new-line-format=""'
alias diff='diff -u'

# [su・sudo | SanRin舎](http://sanrinsha.lolipop.jp/blog/2012/05/su%E3%83%BBsudo.html)
# alias sudo='sudo -E '

if grep --help 2>&1 | grep color 1>/dev/null 2>&1; then
    alias grep='grep --color=auto'
fi

# Man {{{1
# ============================================================================
# manのpagerとしてvimの:Manを使う。
# http://vim.wikia.com/wiki/Using_vim_as_a_man-page_viewer_under_Unix
# cygwinだとcolがなかった、macでもwarningが出たが…
if [[ `uname` == Linux || `uname` == Darwin ]]; then
    export MANPAGER="/bin/sh -c \"col -b -x | \
        $EDITOR -c 'setlocal ft=man nonumber nomod nomodifiable nolist' -c 'noremap <buffer> q :q<CR>' \
                -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""
fi
# man manでman以外出たり、lessになったりする
# function man() {
#     vim -c 'Ref man '$1 -c 'winc j' -c 'q'
# }

# tmux {{{1
# ============================================================================
# test -z $TMUXでTMUXの中にいるか確認できる

# tでtmuxのセッションがなければ作り、あったらそこにアタッチする {{{2
# ----------------------------------------------------------------------------
# -2は256色のためのオプション
# macではクリップボードにアクセスできるようにreattach-to-user-namespaceを使う
#
# e.g.
# https://gist.github.com/1462391
# https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard
# http://yonchu.hatenablog.com/entry/20120514/1337026014
function t {
    # tmuxの中でもscreenの中でもない場合
    if tmux has-session >/dev/null 2>&1; then
        #  セッションがあるならそこにアタッチ
        tmux -2 attach
    else
        # Macでコピーできるようにする
        if [[ $OSTYPE == darwin* ]] && hash reattach-to-user-namespace 2>/dev/null; then
            # on OS X force tmux's default command to spawn a shell in the user's namespace
            tmux_config='set-option -g default-command "reattach-to-user-namespace -l $SHELL"'
            # reattach-to-user-namespaceを設定するとcopy-modeでクリップボードコピーをしなくなるのでcopy-pipeする
            # tmux_config="$tmux_config\n"'bind-key -t vi-copy y copy-pipe "reattach-to-user-namespace pbcopy"'
        fi

        tmux_config=$(cat $HOME/.tmux.conf)"
        $tmux_config
        # シェルのプロンプトをさかのぼる
        bind @ copy-mode \; send-keys ? C-u "$(whoami)"@ C-m n
        "
        tmux -2 -f <(echo "$tmux_config") new-session
    fi
}

# sshでログインし直してtmuxにアタッチしたときに、ssh-agentが切れる問題を解決する {{{2
# ----------------------------------------------------------------------------
if [[ "$SSH_AUTH_SOCK" =~ /tmp/ssh-.*/agent\.[0-9]+ ]]; then
  ln -fs "$SSH_AUTH_SOCK" "$HOME/.ssh/auth_sock"
  export SSH_AUTH_SOCK="$HOME/.ssh/auth_sock"
fi

if [[ -n "$SSH_AUTH_SOCK" && ! -S "$SSH_AUTH_SOCK" ]]; then
  for s in /tmp/ssh-*/agent.[0-9]*; do
    if [[ -S "$s" ]]; then
      ln -fs "$s" "$HOME/.ssh/auth_sock"
      break
    fi
  done
fi

# junkfile {{{1
# ============================================================================
cdw()
{
  dir="${JUNKFILE}/$(date +'%Y/%m')"
  test -d "$dir" || mkdir -p "$dir"
  cd "$dir"
}

# gisty {{{1
# ============================================================================
export GISTY_DIR="$HOME/gists"
export GISTY_SSL_VERIFY="NONE"

# PHP {{{1
# ============================================================================
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

# mac {{{1
# ==============================================================================
if [ "$os" = mac ]; then
    function launchctl-reload()
    {
        launchctl unload $1
        launchctl load $1
    }
fi

# .sh/rc_cygwin.sh {{{1
# ============================================================================
if [[ `uname` = CYGWIN* && -f ~/.sh/rc_cygwin.sh ]]; then
    . ~/.sh/rc_cygwin.sh
fi

# .sh/rc_local.sh {{{1
# ============================================================================
if [ -f ~/.sh/rc_local.sh ]; then
    . ~/.sh/rc_local.sh
fi

# if [ $SHLVL -eq 1 ]; then # tmux, screenを起動していないとき
#     # 回線が切られた時にlogoutする。.bash_logout等を実行するための設定
#     trap logout HUP
# fi


# vim:ft=sh
