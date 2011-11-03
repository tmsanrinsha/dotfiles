# bash, zsh共通設定の読み込み
if [ -f ~/.bashrc ]; then
    . ~/.zashrc
fi

# PS1="\[\e[0;36m\][\u@\h \w]\\$ \[\e[0m\]"
PS1="\[\e[0;${col}m\][\h \w]\\$ \[\e[0m\]"
#PS1="\[\e[0;${col}m\][\u@\h \w]\\$ \[\e[0m\]"
 
#前方一致でヒストリ検索
#bind '"\e[A": history-search-backward'
#bind '"\e[0A": history-search-backward'
#bind '"\e[B": history-search-forward'
#bind '"\e[0B": history-search-forward'
bind '"\C-n": history-search-forward'
bind '"\C-p": history-search-backward'
 
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

if [ -f ~/.bash_option ]; then
    . ~/.bash_option
fi
