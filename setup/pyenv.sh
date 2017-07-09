#!/usr/bin/env zsh

if [[ $OSTYPE =~ 'darwin' ]]; then
  brew install pyenv
  brew install pyenv-virtualenv
else
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
  git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
fi
