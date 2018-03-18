#!/bin/sh
# ファイルを解凍するシェルスクリプト

COMMAND="${0##*/}"
usage() {
    echo "usage: ${COMMAND} filename"
    exit
}

[ "$1" = '-h' -o "$1" = '--help' -o $# -ne 1 ] && usage

# 解凍方法は
# http://tukaikta.blog135.fc2.com/blog-entry-223.html
# http://uguisu.skr.jp/Windows/tar.html
# に従った
case $1 in
    *.tar | *.tgz | *.tar.gz | *.tar.bz2 | *.tbz | *.tbz2 | *.tar.xz | *.tar.lzma | *.tlz | *.tar.Z)
        tar xvf "$1";;
    # 古いtarの場合
    *.tar)
        tar xvf "$1";;
    *.tgz | *tar.gz)
        gzip -dc "$1" | tar xvf -;;
    *.tar.bz2 | *tbz | *tbz2)
        bzip2 -dc "$1" | tar xvf -;;
    *.tar.Z)
        uncompress -c "$1" | tar xvf -;;
    *.lzh)
        lha e "$1";;
    *.zip)
        unzip "$1";;
    *.bz2)
        bzip2 -dc "$1";;
    *.gz)
        gunzip "$1";;
    *.Z)
        uncompress "$1";;
    *.arj)
        unarj "$1";;
    *.rpm)
        if ! which rpm2cpio.pl 1>/dev/null 2>&1; then
            cat <<EOS
rpm2cpio.pl not found. Please install
for Mac:
    brew install rpm2cpio
EOS
            exit 1
        fi
        rpm2cpio.pl "$1" | cpio -id;;
    *)
        echo 'unknown extension';
        exit 1;;
esac
