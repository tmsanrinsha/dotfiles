#!/usr/bin/env bash
set -ex

# mac用Rictyインストールスクリプト

function command_exists {
  hash "$1" 2>/dev/null;
}

command_exists fontforge || brew install fontforge
git clone https://github.com/yascentur/Ricty.git ~/git/Ricty
cd ~/git/Ricty
curl -O http://levien.com/type/myfonts/Inconsolata.otf
curl -O http://iij.dl.sourceforge.jp/mix-mplus-ipa/59022/migu-1m-20130617.zip
unzip migu-1m-20130617.zip
sh ricty_generator.sh Inconsolata.otf migu-1m-20130617/migu-1m-regular.ttf migu-1m-20130617/migu-1m-bold.ttf
cp -f Ricty*.ttf ~/Library/fonts
fc-cache -vf
