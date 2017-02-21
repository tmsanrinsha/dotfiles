# vim {{{1
# ============================================================================
alias v='vim'
alias vi='vim'
alias view='vim -R' # readonlyで開く
alias vis="vim -S ~/.cache/vim/session.vim"
alias vsh="vim -c 'VimShell'"
alias vf="vim -c 'VimFiler'"
# 最小限の構成
alias vim-min='vim -N -U NONE -i NONE --noplugin'
# vimの起動時間をプロファイルする
alias vim-profile='profile=~/.cache/vim/profile.txt; vim --startuptime $profile +q && vim $profile; \rm $profile; unset profile'
# Vim scriptのfileのプロファイル
# [vimrc のどこが重いのかを調べるもう1つの方法 - 永遠に未完成](http://thinca.hatenablog.com/entry/20120316/1331836420)

# if [ -x $HOME/local/share/vim/vim73/macros/less.sh ]; then
#     alias vl="$HOME/local/share/vim/vim73/macros/less.sh"
# fi

# git {{{1
# ============================================================================
alias g='git'
alias gal='alias | grep git | peco'
alias ga='git add'
alias gb='git branch -vv'
alias gci='git commit'
alias gco='git checkout'
alias gd='git d'
alias gdw='git dw'
alias gdr='git diff remotes/origin/master'
alias gfo='git fetch origin'
alias gfu='git fetch upstream'
alias gi='git init'
alias gl='git hist -n 10'
alias gla='git hist'
alias glv='git log | vim -R -'
alias gm='git merge'
alias gpl='git pull'
alias gplr='git pull --rebase origin master'
alias gplum='git pull upstream master'
alias gps='git push'
alias gmt='git mergetool'
alias grb='git rebase'
alias grbi='git rebase -i'
alias grbom='git rebase origin/master'
alias grt='git remote -v'
alias gs='git status'

# gitのルートディレクトリに移動
alias cdt='cd `git rev-parse --show-toplevel`'

# PHP {{{1
# ============================================================================
# https://getcomposer.org/doc/articles/troubleshooting.md#xdebug-impact-on-composer
# Load xdebug Zend extension with php command
alias php='php -dzend_extension=xdebug.so'
# PHPUnit needs xdebug for coverage. In this case, just make an alias with php command prefix.
# alias phpunit='php $(which phpunit)'
alias phpunit='php $(which phpunit.sh) --colors'
alias php-cs-fixer='php-cs-fixer.sh --diff'

# tail {{{1
# ============================================================================
# alias t='tail'
alias tf='tail -f'

if [ "$os" = mac ]; then
  alias taa='tail -f /var/log/apache2/access_log'
  alias tae='tail -f /var/log/apache2/error_log'
elif [ "$os" = linux ]; then
  alias taa='tail -f /var/log/httpd/access_log'
  alias tae='tail -f /var/log/httpd/error_log'
fi

# open {{{1
# ============================================================================
if [ "$os" = mac ]; then
    alias excel='open -a Microsoft\ Excel'
    alias firefox='open -a Firefox'
fi

# heroku {{{1
# ============================================================================
if [ "$os" = mac ]; then
    alias h='heroku'
fi

# knife {{{1
# ============================================================================
if command_exists knife; then
    alias k='knife'
    alias knd='knife node delete'
    alias knl='knife node list'
    alias kns='knife node show'
    alias ksn='knife search node'
    alias ksna='knife search node "*:*"'
fi

# ls {{{1
# ============================================================================
alias l='ls'
alias ll='ls -l'
# . ..以外の.で始まるファイルも表示
alias la='ls -A'
alias lla='ls -la'
alias lld='ls -ld'

# other {{{1
# ============================================================================
alias bc='bc -l'
alias cal="cal | grep -C6 \"\$(date +'%-d')\""

alias hist='history'

# sudoを最後にスペースを入れたエイリアスにする。
# こうすることでsudo llなどがsudo ls -lに展開されるようになる。
# これはaliasの値がスペースかタブで終わっている場合は次のコマンドがエイリアス展開できるか確認する
# という仕様のため
# [なんで末尾にスペース入れるだけで sudo で alias を有効にできるわけ？ « blog.hekt.org](http://archive.blog.hekt.org/archives/5085/)
alias s='sudo '
alias sudo='sudo '

alias cl="crontab -l"
alias ce="crontab -e"

alias j='cdr'

alias egrep='egrep --color=auto'

if [ "$os" = freebsd ];then
    alias find='find -E'
fi

alias pg='ps aux | grep -v grep | grep'
alias pe='ps aux | egrep'
alias pk='pkill -f'

# tree
# -F:ディレクトリなら/をつけるなど
# -C:color は付けないときがautoの挙動になって、通常はcolor、パイプがあるときはcolorじゃなくなる
# -l:ディレクトリのシンボリックリンクを追う
alias tree='tree -Fl'

alias apache_check='apachectl configtest'
alias apache_restart='sudo apachectl restart'

alias sr="exec $SHELL -l"

# カレントディレクトリ以下のファイルに書き込み権限を与える
alias smw='find . -type f -print0 | xargs -0 -I{} sudo chmod a+w {}'
# カレントディレクトリのファイル名をFull Pathで表示
alias fp='find `pwd` -maxdepth 1 -mindepth 1'
# ファイルを解凍するシェルスクリプト
alias dc='decomp.sh'
# find $1 type f -print0 | xargs -0 egrep --color=auto $2
alias fxg='fxg.sh'
# Linuxのバージョンを表示するコマンド
# http://blog.layer8.sh/ja/2011/12/23/linux%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC%E3%81%AE%E3%83%90%E3%83%BC%E3%82%B8%E3%83%A7%E3%83%B3%E3%82%84os%E5%90%8D%E3%82%92%E8%AA%BF%E3%81%B9%E3%82%8B%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89linux/
alias version='cat /etc/`ls /etc -F | grep "release$\|version$"`'

alias decode_html_entity='php -r '\''echo html_entity_decode($argv[1], ENT_NOQUOTES, "UTF-8")."\n";'\';
alias jqq='python -m json.tool | python -c "import re,sys;chr=__builtins__.__dict__.get(\"unichr\", chr);sys.stdout.write(re.sub(r\"\\\\u[0-9a-f]{4}\", lambda x: unichr(int(\"0x\" + x.group(0)[2:], 16)), sys.stdin.read()))"'

# svnとtreeの文字化け対策
alias lcc="export LC_CTYPE='C'"
# 日本語入力用
alias lcu="export LC_CTYPE='ja_JP.UTF-8'"

# リンク切れのリンクを削除する
function clean-symlink() {
    if [ "$1" = '--force' ]; then
        find . -type l -exec bash -c 'test -e "{}" || echo "{}" && rm -r "{}"' \;
    else
        find . -type l -exec bash -c 'test -e "{}" || echo "{}"' \;
    fi
}
