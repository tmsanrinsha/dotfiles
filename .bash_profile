if [ -x $HOME/local/bin/zsh ]; then
    SHELL=$HOME/local/bin/zsh
    exec $HOME/local/bin/zsh -l
elif which zsh 1>/dev/null 2>&1; then
    SHELL=`which zsh`
    exec zsh -l
fi

if [ -f ~/.rc/.zash_profile ]; then
        . ~/.rc/.zash_profile
fi

if [ -f ~/.rc/.bashrc ]; then
        . ~/.rc/.bashrc
fi
