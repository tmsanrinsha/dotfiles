#!/usr/bin/env bash
set -ex

if [ "$#" -ne 1 ]; then
    exit
fi

home=${1%/}

if [[ "$OSTYPE" =~ cygwin ]];then
    # Windowsのメッセージの文字コードをcp932からutf-8に変更
    # なぜか英語になっちゃう
    cmd /c chcp 65001
    # [Chapter 3. Using Cygwin](https://cygwin.com/cygwin-ug-net/using.html#pathnames-symlinks)
    export CYGWIN="winsymlinks $CYGWIN"
fi


cd $home

# ディレクトリがなければ作る
# 空白があるディレクトリに対応するため、ヌル文字で区切ってfindする
# [delimiter - bash "for in" looping on null delimited string variable - Stack Overflow](http://stackoverflow.com/questions/8677546/bash-for-in-looping-on-null-delimited-string-variable)
while IFS= read -r -d '' dir; do
    dir=${dir#./}
    test -d "$HOME/$dir" || mkdir "$HOME/$dir"
done < <(find . -mindepth 1 -type d -print0)

# whileを使わないでxargsを使う方法
# find $home -type d -mindepth 1 -print0 | sed "s,$home,$HOME,g" | xargs -0 -I{} mkdir -p {}

# ファイルに関してはシンボリックリンクを貼る
while IFS= read -r -d '' file; do
    file=${file#./}
    # 実体ファイルがある場合はバックアップをとる
    if [ -f "$HOME/$file" -a ! -L "$HOME/$file" ]; then
        mv "$HOME/$file" "$HOME/${file}.bak"
    fi
    # シンボリックリンクは削除
    if [ -L "$HOME/$file" ]; then
        rm "$HOME/$file"
    fi
    ln -sv "$home/$file" "$HOME/$file"
done < <(find . -type f ! -regex '.*swp.*' ! -regex '.*.DS_Store' -print0)
