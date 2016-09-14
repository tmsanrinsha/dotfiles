if [ -x $HOME/local/bin/zsh ]; then
    SHELL=$HOME/local/bin/zsh
    exec $HOME/local/bin/zsh -l
elif command_exists zsh; then
    SHELL=`which zsh`
    exec zsh -l
fi

if [ -f ~/.zash_profile ]; then
        . ~/.zash_profile
fi

if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi
