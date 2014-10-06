#!/usr/bin/env bash

while getopts p: OPT
do
    case $OPT in
        "p" )
            port=$OPTARG;;
    esac
done

echo $port
echo $OPIND
# オプション部分を取り除く
shift `expr $OPTIND - 1`
host=$1
command=`echo $2 | sed 's/sh -c "LC_TIME=C \([^"]\+\)"/\1/'`
echo $command | ftp $host
# ftp.sh  localhost 'sh -c "LC_TIME=C ls -lFa /"' '/'
# command_line = ftp -p 22 localhost 'sh -c "LC_TIME=C ls -lFa /"' '/'

# .vim/bundle/unite-ssh/autoload/unite/sources/ssh.vim:707 でコマンド実行'

