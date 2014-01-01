#!/usr/bin/env bash
set -ex
# http://rcmdnk.github.io/blog/2013/08/11/computer-linux-windows-cygwin/
mkdir -p $HOME/local/stow
cd $HOME/local/stow
# $HOME/local/stow/srcにDownload
if which curl;then
    curl='curl -L'
elif which wget;then
    curl='wget -O -'
else
    echo 'curlまたはwgetをインストールしてください'
    exit 1
fi

$curl http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz | gzip -dc | tar xf -
stow_ver=$(ls)
cd $stow_ver
mkdir src
ls | grep -v src | xargs -I{} mv {} src
cd src
./configure --prefix=$HOME/local/stow/$stow_ver
make && make install
cd ~/local/stow
./$stow_ver/bin/stow $stow_ver
