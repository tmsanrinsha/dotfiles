#!/usr/local/bin/bash -x
# vimのpluginをインストールする
cd ~/git &&
# vim-emacscommandline
git clone git://github.com/houtsnip/vim-emacscommandline.git &&
cp -r vim-emacscommandline/* ~/.vim
