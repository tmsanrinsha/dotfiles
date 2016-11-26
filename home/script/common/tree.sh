#!/usr/bin/env bash
# set -x
# ORIGINAL: http://d.hatena.ne.jp/teramako/20071108/tree_using_find_and_sed
# The Tree Command for Linux Homepageにあるtreeの方が高機能で良い
# 参照:http://sanrinsha.lolipop.jp/blog/2012/01/treeunix%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89.html#more-9162

COMMAND="${0##*/}"
usage() {
    echo "${COMMAND} <find command options>"
    exit
}

DIR=.

for OPT in $*
do
    case $OPT in
        '-h'|'--help' )
            usage
            ;;
        '-L' )
            maxdepth="-maxdepth $2"
            shift 2
            ;;
        * )
            [ -d "$1" ] && DIR=$1
            shift
    esac
done

echo ${DIR}
cd ${DIR}
find "${DIR}" $maxdepth | \
sed -e "s,^${DIR},," \
       -e '/^$/d' \
       -e 's,[^/]*/\([^/]*\)$,|--\1,' \
       -e 's,[^/]*/,   ,g' \
