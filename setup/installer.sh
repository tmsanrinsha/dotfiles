#!/usr/bin/env bash
set -ex

# curl -kL https://raw.github.com/tmsanrinsha/dotfiles/master/setup/installer.sh | bash
if [ ! -d ~/git/tmsanrinsha ]; then
    git clone git://github.com/tmsanrinsha/dotfiles.git ~/git/tmsanrinsha/dotfiles
fi
bash ~/git/tmsanrinsha/dotfiles/setup/setup.sh
