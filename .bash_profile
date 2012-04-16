if [ -f $HOME/local/bin/zsh ]; then
    SHELL=$HOME/local/bin/zsh
    exec $HOME/local/bin/zsh -l
fi

if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi
bash
