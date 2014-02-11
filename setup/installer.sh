#!/usr/bin/env bash
set -ex

# curl -kL https://raw.github.com/tmsanrinsha/dotfiles/master/setup/installer.sh | bash
if [ ! -d ~/git/tmsanrinsha ]; then
    mkdir -p ~/git/tmsanrinsha
    cd ~/git/tmsanrinsha
    git clone git://github.com/tmsanrinsha/dotfiles.git
fi
bash ~/git/tmsanrinsha/dotfiles/setup/setup.sh
