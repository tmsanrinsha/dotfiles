#!/bin/bash

# [bashで256色表示するスクリプト用意しておくと便利 - Qiita](http://qiita.com/soramugi/items/ab82f30a5906851472cc)
echo '
256色
前: 38;05;色番号
背: 48;05;色番号
'
for i in {0..255} ; do
  printf "\x1b[38;05;${i}m 38;05;${i} "
done
echo ''
for i in {0..255} ; do
  printf "\x1b[48;05;${i}m 48;05;${i} "
done
echo ''
