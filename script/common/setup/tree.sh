#!/usr/bin/env bash
set -xe

test -d ~/local/src || mkdir -p ~/local/src
cd ~/local/src
curl ftp://mama.indstate.edu/linux/tree/tree-1.6.0.tgz | gzip -dc | tar xf -
cd tree-1.6.0
if [[ `uname` = FreeBSD ]]; then
    # Makefileの変更。それぞれ
    # - prefixの変更
    # - Linux defaultsをコメントアウト
    # - FreeBSDの設定
    sed -i ""\
        -e 's|prefix = /usr|prefix = ${HOME}/local|'\
        -e 's/^CFLAGS/#CFLAGS/' -e 's/^LDFLAGS/#LDFLAGS/'\
        -e 's/#CFLAGS=-O2 -Wall -fomit-frame-pointer/CFLAGS=-O2 -Wall -fomit-frame-pointer/' -e 's/#LDFLAGS=-s/LDFLAGS=-s/' -e 's/#OBJS+=strverscmp.o/OBJS=tree.o unix.o html.o xml.o hash.o color.o strverscmp.o/'\
    Makefile
fi

gmake && gmake install
