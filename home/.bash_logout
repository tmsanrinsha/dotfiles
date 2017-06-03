# bash, zsh共通設定の読み込み
if [ -f ~/.sh/logout.sh ]; then
    . ~/.sh/logout.sh
fi

if [ -f ~/.bash_logout.local ]; then
    . ~/.bash_logout.local
fi
