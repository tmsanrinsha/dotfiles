if [ -f $HOME/local/bin/zsh ]; then
    SHELL=$HOME/local/bin/zsh
    exec $HOME/local/bin/zsh -l
fi

if [ -f /usr/local/bin/zsh ]; then
    SHELL=/usr/local/bin/zsh
    exec /usr/local/bin/zsh -l
fi

if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi
bash
