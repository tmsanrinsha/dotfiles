#!/usr/local/bin/bash -x
# screenを$HOME/local/bin以下にインストールする
# うまくいかなかった
# http://yskwkzhr.blogspot.com/2011/12/lets-use-development-version-gnu-screen.htmlの
# 開発版 GNU Screen 導入手順に従う
GIT_DIR=$HOME/git
mkdir -p $HOME/local/{bin,src}
cd $HOME/local/src/ || exit 1
# $HOME/loca/srcにDownload
# curl, wgetの確認
if which curl;then
    CURL='curl -O'
elif which wget;then
    # -Nは上書きオプション
    CURL='wget -N'
else
    echo 'curlまたはwgetをインストールしてください'
    exit 1
fi

# m4のインストール
VERSION=1.4.16 
$CURL http://ftp.gnu.org/gnu/m4/m4-${VERSION}.tar.bz2
bzip2 -dc m4-${VERSION}.tar.bz2 | tar xvf - || exit 1
cd m2-${VERSION} || exit 1
./configure --prefix=$HOME/local && make && make install || exit 1
cd ..

# autoconfのインストール
VERSION=2.68
$CURL http://ftp.gnu.org/gnu/autoconf/autoconf-${VERSION}.tar.bz2
bzip2 -dc autoconf-${VERSION}.tar.bz2 | tar xvf - || exit 1
cd autoconf-${VERSION} || exit 1
./configure --prefix=$HOME/local && make && make install || exit 1

# screenのインストール
if which git;then
    :
else 
    echo 'gitをインストールしてください'
    exit 1
fi

cd $HOME/git || exit 1
git clone git://git.savannah.gnu.org/screen.git || exit 1
cd screen/src || exit 1
./autogen.sh || exit 1
./configure \
--prefix=$HOME/local \
--enable-pam \
--enable-colors256 \
--enable-rxvt_osc \
--enable-use-locale \
--enable-telnet || exit 1
make & make install
