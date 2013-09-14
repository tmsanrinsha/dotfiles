# bash, zsh共通設定の読み込み
if [ -f ~/.rc/.zash_logout ]; then
    . ~/.rc/.zash_logout
fi

if [ -f ~/.rc/.bash_logout.local ]; then
    . ~/.rc/.bash_logout.local
fi
