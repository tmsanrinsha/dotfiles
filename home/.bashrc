# bash, zsh共通設定の読み込み
if [ -f ~/.zashenv ]; then
    . ~/.zashenv
fi
if [ -f ~/.zashrc ]; then
    . ~/.zashrc
fi

#前方一致でヒストリ検索
#bind '"\e[A": history-search-backward'
#bind '"\e[0A": history-search-backward'
#bind '"\e[B": history-search-forward'
#bind '"\e[0B": history-search-forward'
bind '"\C-n": history-search-forward'
bind '"\C-p": history-search-backward'

# 補完の設定
complete -d cd
complete -c man

# set prompt

## Solarized
## https://github.com/seebi/dircolors-solarized
## 現在のホストによってプロンプトの色を変える。
## http://absolute-area.com/post/6664864690/zshを参考にした
#if [ `uname` = FreeBSD ];then
#    colnum=$((0x`hostname | md5 | cut -c1` % 8))
#else
#    colnum=$((0x`hostname | md5sum | cut -c1` % 8))
#fi
## `hostname | md5 | cut -c1`
## hostnameをmd5でハッシュに変更して、最初の一文字を取る
## $((0x`...` % 8))
## これを16進法の数値にして8の余りを求める。
## 8の余りを求めたのはsolarizedの8色だけ使いたいので
#case $colnum in
#    0) col=136;;  # yellow   
#    1) col=166;;  # brred    
#    2) col=160;;  # red      
#    3) col=125;;  # magenta  
#    4) col=61;;   # brmagenta
#    5) col=33;;   # blue     
#    6) col=37;;   # cyan     
#    7) col=64;;   # green    
#esac

# 現在のホストによってプロンプトの色を変える。
# http://absolute-area.com/post/6664864690/zshを参考にした
# 256色の内、カラーで背景黒の時見やすい色はこの217色かな
colArr=({1..6} {9..14} {22..186} {190..229})
# xtermの色についてはこちら
# http://frexx.de/xterm-256-notes/

# hostnameをmd5でハッシュに変更する
# 長いとエラーが出るので最初の8文字を使う
if [ `uname` = FreeBSD ];then
    num=$((0x`hostname | md5 | cut -c1-8` % 217)) # zshの配列のインデックスは0から
else
    num=$((0x`hostname | md5sum | cut -c1-8` % 217))
fi
PS1="\[\e[38;5;${colArr[$num]}m\][\h:\w]\\$ \[\e[0m\]"
#PS1="\[\e[0;${col}m\][\u@\h \w]\\$ \[\e[0m\]"
 
 
#複数の端末間でコマンド履歴(history)を共有する
#http://iandeth.dyndns.org/mt/ian/archives/000651.html
function share_history {  # 以下の内容を関数として定義
    history -a  # .bash_historyに前回コマンドを1行追記
    history -c  # 端末ローカルの履歴を一旦消去
    history -r  # .bash_historyから履歴を読み込み直す
}
PROMPT_COMMAND='share_history'  # 上記関数をプロンプト毎に自動実施
shopt -u histappend   # .bash_history追記モードは不要なのでOFFに
export HISTSIZE=9999  # 履歴のMAX保存数を指定
export HISTFILE=~/.bash_history  # 履歴のMAX保存数を指定

#-------------------------------------------------------------------------------
# screenの設定
#-------------------------------------------------------------------------------
#実行中のコマンドまたはカレントディレクトリの表示
#.screenrcでterm xterm-256colorと設定している場合
if [ $TERM = xterm-256color ];then
    function screen_title {
        echo -ne "\ek$(basename $(pwd))@$(hostname | cut -d . -f 1)\e\\"
    }
    PROMPT_COMMAND="$PROMPT_COMMAND; screen_title" 
fi

if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi
