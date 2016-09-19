#!/usr/bin/env bash

if [ -x /Applications/MacVim.app/Contents/MacOS/Vim ]; then
    vim=/Applications/MacVim.app/Contents/MacOS/Vim
    else
    vim=vim
fi

if [[ $(echo "$($vim --version | head -n1 | cut -d' ' -f5) >= 7.4" | bc) -eq 1 ]];then
    $vim -N -u $HOME/.vimrc -c "try | call dein#update() | finally | qall! | endtry" -U NONE -i NONE -V1 -e -s || :
fi
