#!/bin/sh
# ファイルを解凍するシェルスクリプト

COMMAND="${0##*/}"
usage() {
    echo "usage: ${COMMAND} filename"
    exit
}

[ "$1" = '-h' -o "$1" = '-help' -o $# -ne 1 ] && usage

# 変数展開して一番後ろの拡張子の取得
EXTENSION="${1##*.}"
# 後ろから2番目の拡張子がtarのときはtarを追加する
if echo $1 | grep "\.tar\.[^.]*$" 1>/dev/null 2>&1; then
    EXTENSION=tar.$EXTENSION
fi

# 解凍方法は
# http://uguisu.skr.jp/Windows/tar.html
# に従った
case $EXTENSION in
    "tgz" | "tar.gz") gzip -dc $1 | tar xvf -;;
    "lzh") lha e $1;;
    "zip") unzip $1;;
    "bz2") bzip2 -dc $1;;
    "tar.bz2" | "tbz" | "tbz2") bzip2 -dc $1 | tar xvf -;;
    "tar.Z") uncompress -c $1 | tar xvf -;;
    "gz") gunzip $1;;
    "Z") uncompress $1;;
    "tar") tar xvf $1;;
    "arj") unarj $1;;
    *) echo 'unknown extension'; exit 1;;
esac
