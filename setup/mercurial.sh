#!/usr/bin/env bash -x
# http://mercurial.selenic.com/release/で最新バージョンを確かめる
VERSION=2.0.1

mkdir -p $HOME/local/{bin,src}
cd $HOME/local/src/ || exit 1
# $HOME/loca/srcにDownload
if which curl;then
    curl -O http://mercurial.selenic.com/release/mercurial-${VERSION}.tar.gz || exit 1
elif which wget;then
    # -Nは上書きのオプション
    wget -N http://mercurial.selenic.com/release/mercurial-${VERSION}.tar.gz || exit 1
else
    echo 'curlまたはwgetをインストールしてください'
    exit 1
fi

# 解凍
gzip -dc mercurial-${VERSION}.tar.gz | tar xvf -

cd mercurial-$VERSION || exit 1
# ここで失敗
make install RREFIX=$HOME/local
