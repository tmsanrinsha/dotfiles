#!/usr/bin/env bash
set -ex
# 自分のホームディレクトリにVimをインストールする
# 参考にしたサイト
# http://www.glidenote.com/archives/422
# patchesが途中で止まってしまうので最新版にはならない

# CentOSの場合はこちらを参照
# http://d.hatena.ne.jp/deris/20120804/1344080402
dir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"

# http://www.vim.org/download.phpで最新バージョンを確かめる
ver=7.4
patch=`curl ftp://ftp.vim.org/pub/vim/patches/${ver}/README | tail -1 | awk '{print $2}' | sed "s/${ver}\.//"`
vimdir=$HOME/vim/${ver}.${patch}

mkdir -p $vimdir/{bin,src}
cd $vimdir/src

if which hg &>/dev/null; then
    # hgを使う
    cd $vimdir
    hg clone https://vim.googlecode.com/hg/ vim
    cd vim
else
    # patchを使う方法
    if which curl;then
        downloader='curl -L'
    elif which wget;then
        downloader='wget -O -'
    else
        echo 'curlまたはwgetをインストールしてください'
        exit 1
    fi

    $downloader ftp://ftp.vim.org/pub/vim/unix/vim-${ver}.tar.bz2 | bzip2 -dc | tar xvf -
    cd vim$(echo $ver | tr -d .)

    # patch
    mkdir -p patches
    cd patches

    if which curl;then
        downloader='curl -O'
    elif which wget;then
        downloader='wget -N'
    fi
    $downloader ftp://ftp.vim.org/pub/vim/patches/${ver}/${ver}.[001-${patch}] || exit 1
    # 非同期にするとよい?
    # http://magicant.txt-nifty.com/main/2008/05/post_256f.html
    #  for i in {001..905}; do; curl -sm 30 -O "ftp://ftp.vim.org/pub/vim/patches/7.3/7.3.$i" > /dev/null & ; done

    cd $vimdir/src/vim$(echo $ver | tr -d .) || exit 1
    # patchの-p0はディレクトリ構造を無視しないオプション
    # http://www.koikikukan.com/archives/2006/02/17-235135.php
    # patchが途中で止まってしまう
    cat patches/${ver}.* | patch -p0
fi

# ./configure --helpでオプションの詳細が見れる
# --with-featuresで何が入るかはこちら
# https://sites.google.com/site/vimdocja/various-html#:version
./configure \
--with-features=big \
--enable-multibyte \
--enable-pythoninterp \
--disable-gui \
--without-x \
--prefix=$vimdir
# --with-local-dir=$HOME/local \
# LDFLAGS="-L$HOME/local/lib" \
# CFLAGS="-I$HOME/local/include"

make && make install
