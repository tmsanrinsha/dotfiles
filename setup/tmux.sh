#!/usr/bin/env bash
# tmuxを$HOME/local/bin以下にインストールする
mkdir -p $HOME/local/{bin,src}

# curl, wgetの確認
if which curl;then
    # curlを使ってsourceforgeでダウンロードするにはリダイレクトを追うために
    # -Lオプションを付ける必要がある
    # リダイレクトされているか知るには-vオプションを付けて調べる
    # 参照:http://www.miscdebris.net/blog/2010/04/06/use-curl-to-download-a-file-from-sourceforge-mirror/
    CURL='curl -LO'
elif which wget;then
    # -Nは上書きオプション
    CURL='wget -N'
else
    echo 'curlまたはwgetをインストールしてください'
    exit 1
fi

# libeventが必要
# For FreeBSD 6
# ftp://ftp.freebsd.org/pub/FreeBSD/ports/amd64/packages-6-stable/devel/libevent-1.4.14b_2.tbz
VERSION=2.0.16-stable
cd $HOME/local/src/ || exit 1
$CURL https://github.com/downloads/libevent/libevent/libevent-${VERSION}.tar.gz
gzip -dc libevent-${VERSION}.tar.gz | tar xvf - || exit 1
cd libevent-${VERSION} || exit 1
./configure --prefix=$HOME/local || exit 1
make && make install || exit 1

# tmux
# http://sourceforge.net/projects/tmux/files/tmux/で最新バージョンを確かめる
VERSION=1.5
cd $HOME/local/src/ || exit 1
URL=http://sourceforge.net/projects/tmux/files/tmux/tmux-${VERSION}/tmux-${VERSION}.tar.gz
$CURL -LO $URL || exit 1

# 解凍
gzip -dc tmux-${VERSION}.tar.gz | tar xvf - || exit 1
cd tmux-$VERSION || exit 1

# checking for library containing event_init... no
# configure: error: "libevent not found"
# というエラーが出たので、CFLAGSとLDFLAGSを設定
# http://piro.sakura.ne.jp/latest/blosxom/topics/2011-11-22_sakura_tmux.htm
./configure \
CFLAGS="-I$HOME/local/include" LDFLAGS="-L$HOME/local/lib"
--prefix=$HOME/local || exit 1

make || exit 1
make install || exit 1

# tmuxを起動してみると、lost server
# と出てきたダメだった
# http://hagio.org/diary/index.php?20100401
# が関係あり?
