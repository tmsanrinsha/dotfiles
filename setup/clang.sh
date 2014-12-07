#!/usr/bin/env bash
set -ex

# http://clang.llvm.org/get_started.html
# 本の虫: clangのビルド
# http://cpplover.blogspot.jp/2012/03/clang_26.html

mkdir -p $HOME/local/src/clang
cd $HOME/local/src/clang

curl -O 'http://llvm.org/releases/3.4.2/llvm-3.4.2.src.tar.gz'
curl -O 'http://llvm.org/releases/3.4.2/cfe-3.4.2.src.tar.gz'
curl -O 'http://llvm.org/releases/3.4/compiler-rt-3.4.src.tar.gz'

tar xvf llvm-3.4.2.src.tar.gz
tar xvf cfe-3.4.2.src.tar.gz
tar xvf compiler-rt-3.4.src.tar.gz

mv cfe-3.4.2.src   llvm-3.4.2.src/tools/clang
mv compiler-rt-3.4 llvm-3.4.2.src/projects/compiler-rt

mkdir -p build
cd build
../llvm-3.4.2.src/configure --enable-optimized --enable-assertions=no --enable-targets=host-only \
    --prefix=$HOME/local/stow/llvm-3.4.2
make
make install

cd ~/local/stow
# http://gateman-on.blogspot.jp/2013/02/stow.html
# 以下のオプションを付けないと、dirファイルが他パッケージとかぶってエラーが出る
stow llvm-3.4.2 --ignore=share/info/dir
