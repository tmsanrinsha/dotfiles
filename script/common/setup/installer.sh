#!/usr/bin/env bash
set -xe
# 一旦、tmp以下にcloneした後、ホームディレクトリにコピーする
tmp=/tmp/git.$$
git clone git@github.com:tmsanrinsha/dotfiles.git $tmp
cp -R $tmp/ ~/
~/script/common/setup/setup.sh
