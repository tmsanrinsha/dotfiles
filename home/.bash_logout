# bash, zsh共通設定の読み込み
if [ -f ~/.zash_logout ]; then
    . ~/.zash_logout
fi

if [ -f ~/.bash_logout.local ]; then
    . ~/.bash_logout.local
fi
