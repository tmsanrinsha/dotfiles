#!/usr/bin/env bash
set -ex

# curl -kL https://raw.github.com/tmsanrinsha/dotfiles/master/setup/installer.sh | bash

if ! type ghq; then
    test -d ~/bin || mkdir ~/bin
    cd /tmp
    url='https://github.com/motemen/ghq/releases/download/v0.4'
    case `uname` in
        Linux)
            curl -fLO "${url}/ghq_linux_amd64.tar.gz"
            gzip -dc ghq_linux_amd64.tar.gz | tar xf -
            cp /tmp/ghq_linux_amd64/ghq ~/bin
            export PATH=~/bin:$PATH
            ;;
        Darwin)
            if ! type go; then
                brew install go
            fi
            export GOPATH=$HOME/.go
            go get github.com/motemen/ghq
            export PATH=$GOPATH/bin:$PATH
            ;;
        *)
            echo "Don't match anything"
            exit
    esac
fi

SRC_ROOT="$HOME/git"
git config --global --remove-section "ghq" || :
git config --global "ghq.root" "$SRC_ROOT"

ghq get https://github.com/tmsanrinsha/dotfiles
bash $SRC_ROOT/github.com/tmsanrinsha/dotfiles/setup/setup.sh
