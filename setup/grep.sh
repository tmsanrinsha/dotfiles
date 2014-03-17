#!/usr/bin/env bash
set -eux
# stowについて
# http://rcmdnk.github.io/blog/2013/08/11/computer-linux-windows-cygwin/

# 予めディレクトリを作成しておかないと、stowコマンド打った時、
# ディレクトリのシンボリックリンクができてしまう
mkdir -p $HOME/local/{\
stow,\
Library/Perl/5.16,\
bin,\
include,\
share/{doc,info,man}\
}

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

$curl ftp://ftp.jaist.ac.jp/pub/GNU/grep/grep-2.18.tar.xz | tar xvf -
pkg_ver=$(ls)
cd $pkg_ver
./configure --prefix=$HOME/local/stow/$pkg_ver
make
make install
cd ~/local/stow

# http://gateman-on.blogspot.jp/2013/02/stow.html
# 以下のオプションを付けないと、dirファイルが他パッケージとかぶってエラーが出る
stow $pkg_ver --ignore=share/info/dir
