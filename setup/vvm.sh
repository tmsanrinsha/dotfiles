#!/usr/bin/env bash
# http://labs.timedia.co.jp/2011/09/vim-version-manager.html
# VVMを使って、7.3に最新のパッチを当てたvimをインストールする
set -x

if [ ! -f ~/.vvm/etc/login ]; then
    curl https://raw.github.com/kana/vim-version-manager/master/bin/vvm | python - setup
fi

source ~/.vvm/etc/login

vimorg_ver=`curl ftp://ftp.vim.org/pub/vim/patches/7.4/README | tail -1 | awk '{print $2}' | sed 's/\./-/g'`

cd ~
vvm install vimorg--v${vimorg_ver} --with-features=big --enable-multibyte --enable-pythoninterp --disable-gui --without-x
vvm use vimorg--v${vimorg_ver}
