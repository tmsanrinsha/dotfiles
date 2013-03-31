#!/usr/bin/env bash
set -ex
version=5.8
mkdir -p $HOME/local/{bin,src}
cd $HOME/local/src
# $HOME/loca/srcにDownload
if which curl;then
    curl='curl -L'
#    curl http://prdownloads.sourceforge.net/ctags/ctags-${version}.tar.gz | gzip -dc | tar xf - || exit 1
elif which wget;then
    curl='wget -O -'
#    wget -O - http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz | gzip -dc | tar xf - || exit 1
else
    echo 'curlまたはwgetをインストールしてください'
    exit 1
fi

$curl http://prdownloads.sourceforge.net/ctags/ctags-${version}.tar.gz | gzip -dc | tar xf - || exit 1

cd ctags-${version}
./configure --prefix=$HOME/local
make
make install
