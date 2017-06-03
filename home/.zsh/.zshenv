# - zshの実行時間の計測 - SanRin舎
#   https://tmsanrinsha.net/post/2017/03/zsh-profile/
if [[ "$PROFILE_STARTUP" == true ]]; then
  zmodload zsh/zprof
  PS4=$'%D{%s%.} %N:%i> '
  exec 3>&2 2>$HOME/tmp/zsh_profile
  setopt xtrace prompt_subst
fi

if [[ -f ~/.sh/env.sh ]]; then
    . ~/.sh/env.sh
fi

if [[ "$os" = mac ]]; then
    # In order to use this build of zsh as your login shell,
    # it must be added to /etc/shells.
    # Add the following to your zshrc to access the online help:
    unalias run-help
    autoload run-help
    HELPDIR=/usr/local/share/zsh/help

    setopt no_global_rcs
fi

# zshでログイン・ログアウト時に実行されるファイル - Qiita <http://qiita.com/yuku_t/items/40bcc63bb8ad94f083f1>

if [[ -f ~/.sh/env_local.sh ]]; then
    . ~/.sh/env_local.sh
fi
