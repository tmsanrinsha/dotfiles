#!/usr/local/bin/bash -x
## vimのpluginをインストールする
# 後半はgitが必要。gitのダウンロード先は~/git

cd ~/.vim/plugin || exit 1

# sudo.vimのインストール
# root権限でファイルを保存できる
# http://sanrinsha.lolipop.jp/blog/2012/01/sudo-vim.html
if [ ! -f ~/.vim/plugin/sudo.vim ]; then
    curl -o sudo.vim "http://www.vim.org/scripts/download_script.php?src_id=3477"
fi

# buftabs.vimのインストール
if [ ! -f ~/.vim/plugin/buftabs.vim ]; then
    curl -o buftabs.vim "http://www.vim.org/scripts/download_script.php?src_id=15439"
fi

# ここからgitが必要 

# emacscommandline
# コマンドモードをemacsのキーバインドで操作するプラグイン
if [ ! -f ~/.vim/plugin/emacscommandline.vim ]; then
    cd ~/git || exit 1
    git clone git://github.com/houtsnip/vim-emacscommandline.git || exit 1
    cp -r vim-emacscommandline/* ~/.vim || exit 1
fi
