# bash, zsh共通設定の読み込み
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

# 現在のホストによってプロンプトの色を変える。
# http://absolute-area.com/post/6664864690/zshを参考にした
if [ `uname` = FreeBSD ];then
    col=$((0x`hostname | md5 | cut -c1-8` % 226 + 16))
else
    col=$((0x`hostname | md5sum | cut -c1-8` % 226 + 16))
fi
# hostnameをmd5でハッシュに変更する
# 長いとエラーが出るので最初の8文字を使う
# 0-15はdefault terminal color、
# 最後の24色はグレースケールなのでこれを取り除いた226色を使う
# xtermの色についてはこちら
# http://frexx.de/xterm-256-notes/
PS1="\[\e[38;5;${col}m\][\h:\w]\\$ \[\e[0m\]"
#PS1="\[\e[0;${col}m\][\h:\w]\\$ \[\e[0m\]"
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

if [ -f ~/.bash_option ]; then
    . ~/.bash_option
fi
