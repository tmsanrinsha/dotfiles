#!/usr/bin/env bash
set -ex

if [ -d ~/git/tmsanrinsha ]; then
    git clone git@github.com:tmsanrinsha/dotfiles.git ~/git/tmsanrinsha/dotfiles
fi
~/git/tmsanrinsha/dotfiles/script/common/setup/setup.sh
