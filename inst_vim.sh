#!/usr/local/bin/bash -x
# http://www.vim.org/download.phpで最新バージョンを確かめる
VERSION=7.3
mkdir -p $HOME/local/{bin,src}
cd $HOME/local/src/ || exit 1
# Download
if which curl;then
    curl -O ftp://ftp.vim.org/pub/vim/unix/vim-${VERSION}.tar.bz2 || exit 1
elif which wget;then
    # -Nは上書きのオプション
    wget -N ftp://ftp.vim.org/pub/vim/unix/vim-${VERSION}.tar.bz2 || exit 1
else
    echo 'curlまたはwgetをインストールしてください'
    exit 1
fi
bzip2 -dc vim-${VERSION}.tar.bz2 | tar xvf -
cd vim$(echo $VERSION | sed 's/\.//') || exit 1
 
./configure \
--enable-multibyte \
--enable-xim \
--enable-fontset \
--with-features=big \
--prefix=$HOME/local
 
make
make install
