# [zshの起動を高速化する方法 - なっく日報](http://yukidarake.hateblo.jp/entry/2016/02/02/205148)
# zmodload zsh/zprof
# PS4=$'%D{%M%S%.} %N:%i> '
# exec 3>&2 2>$HOME/tmp/startlog
# setopt xtrace prompt_subst

# zshでログイン・ログアウト時に実行されるファイル - Qiita <http://qiita.com/yuku_t/items/40bcc63bb8ad94f083f1>
# if [ -f ~/.zashenv ]; then
#     . ~/.zashenv
# fi

if [ -f ~/.zashenv.local ]; then
    . ~/.zashenv.local
fi
