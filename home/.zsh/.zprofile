if [ -f ~/.zash_profile ]; then
        . ~/.zash_profile
fi

alias | awk '{print "alias "$0}' >! ~/.vim/rc/.vimshrc
