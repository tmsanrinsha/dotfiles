#!/usr/bin/env bash
set -ex
version=5.8
mkdir -p $HOME/local/{bin,src}
cd $HOME/local/src
# $HOME/loca/srcにDownload
if which curl;then
    curl='curl -L'
elif which wget;then
    curl='wget -O -'
else
    echo 'curlまたはwgetをインストールしてください'
    exit 1
fi

$curl http://prdownloads.sourceforge.net/ctags/ctags-${version}.tar.gz | gzip -dc | tar xf -

cd ctags-${version}
./configure --prefix=$HOME/local
make
make install
