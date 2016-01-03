# 実行方法
# $ R --vanilla --slave < R-lang.R
# --vanilla : R の実行環境に保存済みのオブジェクトを読み込まないで、スクリプトを実行する（スクリプトの実行動作への影響が懸念される場合には、つけたほうが無難）

options(repos = "http://cran.ism.ac.jp/")

# installされてない時だけインストール
my_install <- function(x)
{
    if (!require(x, character.only = TRUE)) {
        install.packages(x, dependencies = TRUE)
    }
}

# devtoolsのインストールでエラーが出た時は R | SanRin舎 - http://sanrinsha.lolipop.jp/blog/2015/08/r.html 参照
my_install("devtools")
my_install("rmarkdown")
my_install("dygraphs")
my_install("data.table")
my_install("DT")

# # vimcom関連
# devtools::install_github("jalvesaq/VimCom")
# # コンソールでカラー表示する
# devtools::install_github("jalvesaq/colorout")
# # コンソールの幅の操作
# my_install("setwidth").
