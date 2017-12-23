#!/usr/bin/env bash

PATH="/Applications/MacVim.app/Contents/MacOS:/usr/local/opt/gnu-sed/libexec/gnubin:$HOME/bin:/usr/local/bin:/usr/bin:$PATH"

if [ -x /Applications/MacVim.app/Contents/MacOS/Vim ]; then
    vim=/Applications/MacVim.app/Contents/MacOS/Vim
    else
    vim=vim
fi

if ! which git 1>/dev/null 2>&1; then
  exit
fi

if [[ $(echo "$($vim --version | head -n1 | cut -d' ' -f5) < 7.4" | bc) -eq 1 ]]; then
  exit
fi

dein_repo_dir="$HOME/.cache/vim/dein/repos/github.com/Shougo/dein.vim"

if [[ ! -d "$dein_repo_dir" ]]; then
  git clone https://github.com/Shougo/dein.vim "$dein_repo_dir"
fi

# yes | $vim -N -u $HOME/.vimrc -c "try | call dein#update() | finally | qall! | endtry" -U NONE -i NONE -V1 -e -s || :
$vim -N -u $HOME/.vimrc -c "try | call dein#update() | finally | qall! | endtry" -U NONE -i NONE -V1 -e -s || :

# プラグインのタグを加える
ctags --tag-relative=yes -R --append=yes -f ~/src/github.com/tmsanrinsha/dotfiles/.git/vim.tags --languages=vim --vim-kinds=-m ~/.cache/vim/dein/repos
# スクリプトローカルな関数は必要ないので削除
sed -i'' -e '/^s:/d' ~/src/github.com/tmsanrinsha/dotfiles/.git/tags/vim.tags
