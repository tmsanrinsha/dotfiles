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

# カラー表示化されたmru.vimのインストール
# https://sites.google.com/site/fudist/Home/modify
# if [ ! -f ~/.vim/plugin/mru.vim ]; then
#     curl -o mru.vim "http://www.vim.org/scripts/download_script.php?src_id=11919"
#     curl -Lo mru.patch "https://sites.google.com/site/fudist/files/mru.patch?attredirects=0"
#     patch -p0 < mru.patch
# fi

# yankring.vimのインストール 
# 何故か失敗
#if [ ! -f ~/.vim/plugin/yankring.vim ]; then
#    cd ~/.vim
#    curl -vO yankring.zip "http://www.vim.org/scripts/download_script.php?src_id=16536" | exit 1
#    unzip yankring.zip | exit 1
#    rm yankring.zip | exit 1
#fi

# ここからgitが必要 

# emacscommandline
# コマンドモードをemacsのキーバインドで操作するプラグイン
if [ ! -f ~/.vim/plugin/emacscommandline.vim ]; then
    cd ~/git || exit 1
    git clone git://github.com/houtsnip/vim-emacscommandline.git || exit 1
    cp -r vim-emacscommandline/* ~/.vim || exit 1
fi
