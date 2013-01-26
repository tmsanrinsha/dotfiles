#!/usr/local/bin/bash -x
# zshを$HOME/local/bin以下にインストールする
# http://sourceforge.net/projects/zsh/files/zsh-dev/で最新バージョンを確かめる
VERSION=5.0.2

mkdir -p $HOME/local/{bin,src}
cd $HOME/local/src/ || exit 1
# $HOME/loca/srcにDownload
URL=http://jaist.dl.sourceforge.net/project/zsh/zsh/${VERSION}/zsh-${VERSION}.tar.bz2
if which curl;then
    # curlを使ってsourceforgeでダウンロードするにはリダイレクトを追うために
    # -Lオプションを付ける必要がある
    # リダイレクトされているか知るには-vオプションを付けて調べる
    # 参照:http://www.miscdebris.net/blog/2010/04/06/use-curl-to-download-a-file-from-sourceforge-mirror/
    curl -LO $URL || exit 1
elif which wget;then
    # -Nは上書きのオプション
    wget -N $URL || exit 1
else
    echo 'curlまたはwgetをインストールしてください'
    exit 1
fi

# 解凍
bzip2 -dc zsh-${VERSION}.tar.bz2 | tar xvf - || exit 1
cd zsh-$VERSION || exit 1

./configure \
--enable-multibyte \
--prefix=$HOME/local || exit 1

make || exit 1
make install || exit 1

# ログインシェルの変更
# chsh -s $HOME/loca/bin/zsh  
# で変更しようとすると
# chsh: <$HOME>/loca/bin/zsh: non-standard shell
# というエラーが出て変更できない
# sudo vi /etc/shellsで
# <$HOME>/local/bin/zshを追記しておくと上記のエラーはなくなる
# わざわざ/etc/shells書き換えなくても
# sudo vipwで変更することもできる
# もしPATHを間違えると、ログインできなくなってしまうので
# ログインシェルを変更したら、別の端末を立ち上げてログイン出来るか確認すること

# root権限がなくて、現在のログインシェルがbashの場合は、.bash_profileの最初の部分に
# if [ -f $HOME/local/bin/zsh ]; then
#     SHELL=$HOME/local/bin/zsh
#     exec $HOME/local/bin/zsh -l
# fi
# を書いておく。
# -lはログインシェルとしてzshを起動するオプション
# execを付けると元々のログインシェルがzshの終了を待ち続けることがなくなる。
# psで確認するとbashのプロセスが無いのを確認できる
# ■参照
# ・http://zsh.sourceforge.net/FAQ/zshfaq01.html
#    1.7: I don't have root access: how do I make zsh my login shell?
# ・http://technique.sonots.com/?UNIX%2F%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%2F%E3%82%B7%E3%82%A7%E3%83%AB%E3%83%BB%E3%82%B7%E3%82%A7%E3%83%AB%E7%B5%84%E3%81%BF%E8%BE%BC%E3%81%BF%2Fzsh
# ・http://x68000.q-e-d.net/~68user/unix/pickup?exec
