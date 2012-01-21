#!/usr/local/bin/bash -x
## vimのpluginをインストールする

# sudo.vimのインストール
if [ ! -f ~/.vim/plugin/sudo.vim ]; then
    cd ~/.vim/plugin || exit 1
    curl -o sudo.vim "http://www.vim.org/scripts/download_script.php?src_id=3477"
fi

# buftabs.vimのインストール
if [ ! -f ~/.vim/plugin/buftabs.vim ]; then
    cd ~/.vim/plugin || exit 1
    curl -o buftabs.vim "http://www.vim.org/scripts/download_script.php?src_id=15439"
fi

#cd ~/git &&
## vim-emacscommandline
#git clone git://github.com/houtsnip/vim-emacscommandline.git &&
#cp -r vim-emacscommandline/* ~/.vim
