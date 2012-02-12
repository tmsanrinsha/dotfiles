#!//bin/sh
# find $1 -type f -print0 | xargs -0 grep --color=auto $2を
# するシェルスクリプト
# 引数が1つの場合は、カレントディレクトリを$1で検索

COMMAND="${0##*/}"
usage() {
    echo "${COMMAND} [<dir>] <search name>"
    exit
}
[ "$1" = '-h' -o "$1" = '-help' -o ! \( $# -eq 1 -o $# -eq 2 \) ] && usage

if [ "$#" -eq 1 ];then
    ARG1=.
    ARG2=$1
else
    ARG1=$1
    ARG2=$2
fi

#ドットで始まるディレクトリは検索しない
find $ARG1 -type f ! -regex ".*/\..*/.*" -print0 | xargs -0 egrep --color=auto $ARG2
