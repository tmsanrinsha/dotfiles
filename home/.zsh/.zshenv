# - zshの実行時間の計測 - SanRin舎
#   https://tmsanrinsha.net/post/2017/03/zsh-profile/
if [[ "$PROFILE_STARTUP" == true ]]; then
  zmodload zsh/zprof
  PS4=$'%D{%M%S%.} %N:%i> '
  exec 3>&2 2>$HOME/tmp/startlog
  setopt xtrace prompt_subst
fi

. ~/.sh/env.sh
. ~/.sh/alias.sh

# zshでログイン・ログアウト時に実行されるファイル - Qiita <http://qiita.com/yuku_t/items/40bcc63bb8ad94f083f1>
# if [ -f ~/.zashenv ]; then
#     . ~/.zashenv
# fi

if [ -f ~/.zashenv.local ]; then
    . ~/.zashenv.local
fi
