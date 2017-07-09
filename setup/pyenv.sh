#!/usr/bin/env zsh

if [[ $OSTYPE =~ 'darwin' ]]; then
  brew install pyenv
  brew install pyenv-virtualenv
else
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
  git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
fi

file="$ZDOTDIR/.zshenv.d/pyenv.zsh"

if [[ ! -f $file ]]; then
  echo 'export PYENV_ROOT="$HOME/.pyenv"' > $file
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> $file
  pyenv init - >> $file
  pyenv virtualenv-init - >> $file
fi
