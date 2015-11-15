#!/usr/bin/env R

install.packages("devtools")
# devtoolsのインストールでエラーが出た時は R | SanRin舎 - http://sanrinsha.lolipop.jp/blog/2015/08/r.html 参照

install.packages("data.table")

# vimcom関連
devtools::install_github("jalvesaq/VimCom")
# コンソールでカラー表示する
devtools::install_github("jalvesaq/colorout")
# コンソールの幅の操作
install.packages("setwidth").
