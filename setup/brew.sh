#!/usr/bin/env bash
set -ex

# すでにinstallされているとエラーが出るため、コマンドがあるかをチェックしてからインストール
function brew-install {
    brew list $1 >/dev/null || brew install $1
}
function brew-cask-install {
    brew cask list $1 >/dev/null || brew cask install $1
}

if ! which brew; then
    sudo xcodebuild -license
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ln -fs $(brew --prefix)/Library/Contributions/brew_zsh_completion.zsh ~/.zsh/functions/_brew
fi



brew update  # homebrewの更新
brew upgrade --all # packageの更新
brew cleanup
brew cask cleanup

# for php
# https://github.com/Homebrew/homebrew-php
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/homebrew-php

# for r
brew tap homebrew/science

brew-install ag
brew-install ant
brew-install coreutils
brew tap ethereum/ethereum
brew-install ethereum
brew-install gnu-sed
brew-install go
brew-install graphviz
brew-install hub
brew-install jq
brew-install lftp
brew-install nkf
brew-install node
brew-install pwgen
brew-install pyenv
brew-install python
brew-install r
brew install reattach-to-user-namespace
brew-install ruby
brew-install screen
brew-install ssh-copy-id
brew-install tmux
brew-install tree
brew-install wget
brew-install zsh

# [Patched ctags · shawncplus/phpcomplete.vim Wiki](https://github.com/shawncplus/phpcomplete.vim/wiki/Patched-ctags)
if ! test -f /usr/local/Library/Formula/ctags-better-php.rb; then
    curl https://raw.githubusercontent.com/shawncplus/phpcomplete.vim/master/misc/ctags-better-php.rb > /usr/local/Library/Formula/ctags-better-php.rb
    echo ctags-better-php.rb >> /usr/local/Library/Formula/.gitignore
    brew install ctags-better-php
fi

## caskroom/cask
# brew-install caskroom/cask/brew-cask
# 上はこの2行と同じ
# brew tap caskroom/cask
# brew install brew-cask

# brew-cask-install alfred
# brew-cask-install bettertouchtool
# brew-cask-install clipmenu
# brew cask install firefox
# brew cask install google-chrome
# brew cask install google-japanese-ime
# brew cask install karabiner
# brew cask install playonmac
# # formuraでもinstallできる
# brew-cask-install pandoc

# brew-cask-install evernote

# brew-cask-install android-studio
# brew-cask-install cheatsheet
# brew-cask-install eclipse-ide

# brew-install matplotlib
# brew install pythonでインストールされるpipでインストール
# 失敗
# pip install numpy
# pip install nosy
# pip install ipython
# pip install six
