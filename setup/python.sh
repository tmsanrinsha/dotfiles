#!/usr/bin/env bash
set -eux

# require stow

tmpdir=`mktemp -d /tmp/XXXXXX`
cd $tmpdir
if which curl;then
    curl='curl -L'
elif which wget;then
    curl='wget -O -'
else
    echo 'curlまたはwgetをインストールしてください'
    exit 1
fi

# http://www.python.jp/download/
$curl http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tgz | gzip -dc | tar xf -
pkg_ver=$(ls)
cd $pkg_ver
./configure --prefix=$HOME/local/stow/$pkg_ver
make
make install
cd ~/local/stow

# http://gateman-on.blogspot.jp/2013/02/stow.html
# 以下のオプションを付けないと、dirファイルが他パッケージとかぶってエラーが出る
stow $pkg_ver --ignore=share/info/dir
