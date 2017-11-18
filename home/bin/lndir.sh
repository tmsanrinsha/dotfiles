#!/usr/bin/env bash

# lndirというコマンドがある
# [ディレクトリ内のファイル1つ1つに対して一気にシンボリックリンクを作成する - Qiita](http://qiita.com/krsak/items/394850608ffe530cd6b2)
#   lndirのシェルスクリプト版がある
# 上書きが出来ないので自作

set -e

if [ "$#" -ne 2 ]; then
    exit
fi

fromdir=${1%/}
todir=${2%/}

if [[ "$OSTYPE" =~ cygwin ]];then
    # Windowsのメッセージの文字コードをcp932からutf-8に変更
    # なぜか英語になっちゃう
    cmd /c chcp 65001
    # [Chapter 3. Using Cygwin](https://cygwin.com/cygwin-ug-net/using.html#pathnames-symlinks)
    export CYGWIN="winsymlinks $CYGWIN"
fi


cd $fromdir

# ディレクトリがなければ作る
# 空白があるディレクトリに対応するため、ヌル文字で区切ってfindする
# [delimiter - bash "for in" looping on null delimited string variable - Stack Overflow](http://stackoverflow.com/questions/8677546/bash-for-in-looping-on-null-delimited-string-variable)
while IFS= read -r -d '' dir; do
    dir=${dir#./}
    test -d "$todir/$dir" || mkdir "$todir/$dir"
done < <(find . -mindepth 1 -type d -print0)

# whileを使わないでxargsを使う版
# find $fromdir -type d -mindepth 1 -print0 | sed "s,$fromdir,$todir,g" | xargs -0 -I{} mkdir -p {}

# ファイルに関してはシンボリックリンクを貼る
while IFS= read -r -d '' file; do
  file=${file#./}

  # 実体ファイルがある場合はバックアップをとる
  if [ -f "$todir/$file" -a ! -L "$todir/$file" ]; then
    ln -sfvb "$fromdir/$file" "$todir/$file"
  else
    ln -sfv "$fromdir/$file" "$todir/$file"
  fi

done < <(find . \( -type f -o -type l \) ! -regex '.*swp.*' ! -regex '.*.DS_Store' -print0)
