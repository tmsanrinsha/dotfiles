# 使ってない設定
# j {{{1
# ============================================================================
# if [ -f $ZDOTDIR/plugin/z.sh ]; then
#     _Z_CMD=j
#     source $ZDOTDIR/plugin/z.sh
# fi

# screen {{{1
# ============================================================================
# test -z $STYでscreenの中にいるか確認できる

# screenがインストールされていて、Screenを起動していないときは自動起動
# ただし、.screenrcでterm xterm-256colorと設定しているとする
# if [ $TERM != 'xterm-256color' ];then 
#     # すでに screen セッションがある場合そこに接続し、なければ作成する
#     # screenがないときのエラーは/dev/nullに送る
#     screen -RU 2>/dev/null
#     # screen -rx || screen -D -RR
# fi

# VVM {{{1
# ============================================================================
# test -f ~/.vvm/etc/login && source ~/.vvm/etc/login

# svn {{{1
# ============================================================================
# alias svnvd='svn diff --diff-cmd ~/bin/svn_diff_vim'

# nvm {{{1
# ============================================================================
# http://sanrinsha.lolipop.jp/blog/2012/03/node-jsnvm.html
# if [ -f ~/.nvm/nvm.sh ]; then
#     # nvm.shにnvm用のMANPATHを追加する部分があるが
#     # MANPATHはデフォルトだと空なので
#     # MANPATH="$NVM_DIR/$2/share/man:$MANPATH"
#     # だとnvmのマニュアルへのPATHのみになってしまうので
#     # 予めセットしておく
#     export MANPATH=`manpath`
#
#     . ~/.nvm/nvm.sh
#     nvm alias default v0.6.11 > /dev/null
# fi

# ssh agent {{{1
# ============================================================================
# if [[ `hostname` == *ua.sakura.ne.jp ]]; then
#     export PACKAGESITE=ftp://ftp.jp.freebsd.org/pub/FreeBSD/ports/amd64/packages-8-stable/Latest/
#
#     # ssh-agent
#     # http://sanrinsha.lolipop.jp/blog/2010/09/ssh%E9%96%A2%E9%80%A3.html
#     if [[ `uname` != CYGWIN* ]] && command_exists ssh-agent; then
#         SSH_AGENT_PID=$(ps x | grep ssh-agent 2>/dev/null | grep -v grep | head -1 | awk '{print $1}')
#         SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent.$(expr $SSH_AGENT_PID - 1 2>/dev/null) 2>/dev/null) # $agentPIDが空の時はexprのエラーが出るので/dev/nullに送る
#         if [ -z "$SSH_AGENT_PID" -o -z "$SSH_AUTH_SOCK" ]; then
#             unset SSH_AUTH_SOCK SSH_AGENT_PID
#             eval $(ssh-agent)
#             ssh-add
#         else
#             export SSH_AGENT_PID SSH_AUTH_SOCK
#             # 秘密鍵がセットされてなかったら追加
#             if ! ssh-add -l 1>/dev/null 2>&1 ; then
#                 ssh-add
#             fi
#         fi
#     fi
# fi

# vimshell {{{1
# ============================================================================
# alias | awk '{print "alias "$0}' \
#     | grep -v 'ls --color' \
#     | grep -v 'ls -G' \
#     | grep -v 'vi=vim' >! ~/.vim/rc/.vimshrc

