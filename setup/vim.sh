#!/usr/bin/env bash
set -ex
# 自分のホームディレクトリ以下にVimをインストールする
# http://sanrinsha.lolipop.jp/blog/2012/03/vim%E3%81%AE%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB.html

# CentOSの場合でコンパイルしない場合はこちらを参照
# http://d.hatena.ne.jp/deris/20120804/1344080402

# http://www.vim.org/download.phpで最新バージョンを確かめる
ver=7.4
patch=`curl ftp://ftp.vim.org/pub/vim/patches/${ver}/README | tail -1 | awk '{print $2}' | sed "s/${ver}\.//"`
# vimdir=$HOME/vim/${ver}.${patch}
vimdir=$HOME/local/stow/vim${ver}.${patch}

if which hg &>/dev/null; then
    # hgを使う
    mkdir ~/hg
    cd ~/hg
    hg clone https://vim.googlecode.com/hg/ vim
    cd vim
else
    # patchを使う方法
    mkdir -p $vimdir/{bin,src}
    cd $vimdir/src

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
    cat patches/${ver}.* | patch -p0
fi

if which python; then
    option=--enable-pythoninterp
fi

# ./configure --helpでオプションの詳細が見れる
# --with-featuresで何が入るかはこちら
# http://vim-jp.org/vimdoc-ja/various.html#:ve
./configure \
--with-features=huge \
--enable-multibyte \
--disable-gui \
--without-x \
--prefix=$vimdir \
$option
# --with-local-dir=$HOME/local \
# LDFLAGS="-L$HOME/local/lib" \
# CFLAGS="-I$HOME/local/include"

make
make install

# http://gateman-on.blogspot.jp/2013/02/stow.html
# 以下のオプションを付けないと、dirファイルが他パッケージとかぶってエラーが出る
stow $pkg_ver --ignore=share/info/dir
