#!/usr/bin/env bash
set -ex
# 自分のホームディレクトリにVimをインストールする
# 参考にしたサイト
# http://www.glidenote.com/archives/422
# patchesが途中で止まってしまうので最新版にはならない

# CentOSの場合はこちらを参照
# http://d.hatena.ne.jp/deris/20120804/1344080402

# http://www.vim.org/download.phpで最新バージョンを確かめる
ver=7.3
patches=`curl ftp://ftp.vim.org/pub/vim/patches/${ver}/README | tail -1 | awk '{print $2}' | sed "s/${ver}\.//"`

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

$curl ftp://ftp.vim.org/pub/vim/unix/vim-${ver}.tar.bz2 | bzip2 -dc | tar xvf -
cd vim$(echo $ver | tr -d .)

# patch
mkdir -p patches
cd patches
if which curl;then
    curl -O ftp://ftp.vim.org/pub/vim/patches/${VERSION}/${VERSION}.[001-${PATCHES}] || exit 1
else
    # -Nは上書きのオプション
    wget -N ftp://ftp.vim.org/pub/vim/patches/${VERSION}/${VERSION}.[001-${PATCHES}] || exit 1
fi

cd $HOME/local/src/vim$(echo $VERSION | tr -d .) || exit 1
# patchの-p0はディレクトリ構造を無視しないオプション
# http://www.koikikukan.com/archives/2006/02/17-235135.php
# patchが途中で止まってしまう
cat patches/${VERSION}.* | patch -p0

# ./configure --helpでオプションの詳細が見れる
# --with-featuresで何が入るかはこちら
# https://sites.google.com/site/vimdocja/various-html#:version
./configure \
--with-features=big \
--enable-multibyte \
--enable-pythoninterp \
--disable-gui \
--without-x \
--prefix=$HOME/local
# --with-local-dir=$HOME/local \
# LDFLAGS="-L$HOME/local/lib" \
# CFLAGS="-I$HOME/local/include"

make && make install
