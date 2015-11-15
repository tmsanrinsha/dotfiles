# 実行方法
# $ R --vanilla --slave < R-lang.R
# --vanilla : R の実行環境に保存済みのオブジェクトを読み込まないで、スクリプトを実行する（スクリプトの実行動作への影響が懸念される場合には、つけたほうが無難）

options(repos = "http://cran.ism.ac.jp/")
install.packages("devtools")
# devtoolsのインストールでエラーが出た時は R | SanRin舎 - http://sanrinsha.lolipop.jp/blog/2015/08/r.html 参照

# install.packages("data.table")
#
# # vimcom関連
# devtools::install_github("jalvesaq/VimCom")
# # コンソールでカラー表示する
# devtools::install_github("jalvesaq/colorout")
# # コンソールの幅の操作
# install.packages("setwidth").
