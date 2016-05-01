# zshでログイン・ログアウト時に実行されるファイル - Qiita <http://qiita.com/yuku_t/items/40bcc63bb8ad94f083f1>
if [ -f ~/.zashenv ]; then
    . ~/.zashenv
fi

if [ $os = mac ]; then
    # In order to use this build of zsh as your login shell,
    # it must be added to /etc/shells.
    # Add the following to your zshrc to access the online help:
    unalias run-help
    autoload run-help
    HELPDIR=/usr/local/share/zsh/help

    setopt no_global_rcs
fi
