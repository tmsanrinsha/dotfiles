#!/usr/bin/env bash
set -ex

if ! which brew; then
    sudo xcodebuild -license
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ln -fs $(brew --prefix)/Library/Contributions/brew_zsh_completion.zsh ~/.zsh/functions/_brew
fi

# すでにinstallされているとエラーが出るため、コマンドがあるかをチェックしてからインストール
function brew-install {
    brew list $1 >/dev/null || brew install $1
}
function brew-cask-install {
    brew cask list $1 >/dev/null || brew cask install $1
}

while getopts b OPT
do
  case $OPT in
    "b")
        brew=1;;
  esac
done

if [ "$brew" == '1' ]; then
    brew update  # homebrewの更新
    brew upgrade --all # packageの更新
    brew cleanup
    brew cask cleanup

    # for php
    # https://github.com/Homebrew/homebrew-php
    brew tap homebrew/dupes
    brew tap homebrew/versions
    brew tap homebrew/homebrew-php

    brew tap peco/peco
fi

brew-install ag
brew-install ant
brew-install coreutils
brew-install gnu-sed
brew-install go
brew-install jq
brew-install lftp
# brew-install mercurial
brew-install nkf
brew-install node
brew-install php56
brew-install php56-yaml
brew-install php56-stats
brew-install pwgen
brew-install python
brew install reattach-to-user-namespace
brew-install ruby
brew-install tmux
brew-install tree
brew-install zsh

# [Patched ctags · shawncplus/phpcomplete.vim Wiki](https://github.com/shawncplus/phpcomplete.vim/wiki/Patched-ctags)
if ! test -f /usr/local/Library/Formula/ctags-better-php.rb; then
    curl https://raw.githubusercontent.com/shawncplus/phpcomplete.vim/master/misc/ctags-better-php.rb > /usr/local/Library/Formula/ctags-better-php.rb
    echo ctags-better-php.rb >> /usr/local/Library/Formula/.gitignore
    brew install ctags-better-php
fi

## caskroom/cask
brew-install caskroom/cask/brew-cask

# brew caskでインストールしたものをalfredから検索可能にする
# brew cask alfred link
# brew-cask-install android-studio
brew-cask-install alfred
brew-cask-install bettertouchtool
brew-cask-install cheatsheet
brew-cask-install clipmenu
# brew-cask-install eclipse-ide
# formuraでもinstallできる
brew-cask-install pandoc

# peco/peco
# formulaがないと言われる
# brew install peco

# brew-install matplotlib
# brew install pythonでインストールされるpipでインストール
# 失敗
# pip install numpy
# pip install nosy
# pip install ipython
# pip install six

# brew cask install playonmac
