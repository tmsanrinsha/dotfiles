# [zshの起動を高速化する方法 - なっく日報](http://yukidarake.hateblo.jp/entry/2016/02/02/205148)
# zmodload zsh/zprof
# PS4=$'%D{%M%S%.} %N:%i> '
# setopt xtrace prompt_subst


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

# The next line updates PATH for the Google Cloud SDK.
if [ -f $HOME/google-cloud-sdk/path.zsh.inc ]; then
  source "$HOME/google-cloud-sdk/path.zsh.inc"
fi
