if [ -x $HOME/local/bin/zsh ]; then
    SHELL=$HOME/local/bin/zsh
    exec $HOME/local/bin/zsh -l
elif type zsh 1>/dev/null 2>&1; then
    SHELL=`which zsh`
    exec zsh -l
fi

if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

export PATH="$HOME/.cargo/bin:$PATH"
