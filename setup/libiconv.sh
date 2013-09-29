#!/usr/local/bin/bash -x

mkdir -p $HOME/local/{bin,src}
cd $HOME/local/src/ || exit 1
# $HOME/loca/srcにDownload
if which curl;then
    curl ftp://ftp.ring.gr.jp/pub/GNU/libiconv/libiconv-1.14.tar.gz | gzip -dc | tar xf - || exit 1
elif which wget;then
    # -Nは上書きのオプション
    wget -O - ftp://ftp.ring.gr.jp/pub/GNU/libiconv/libiconv-1.14.tar.gz | gzip -dc | tar xf - || exit 1
else
    echo 'curlまたはwgetをインストールしてください'
    exit 1
fi

cd libiconv-1.14 || exit 1
./configure --prefix=$HOME/local || exit 1
make || exit 1
make install || exit 1
