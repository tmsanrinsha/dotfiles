# zshでログイン・ログアウト時に実行されるファイル - Qiita <http://qiita.com/yuku_t/items/40bcc63bb8ad94f083f1>
# zsh関連の設定ファイルを~/.zsh以下で管理
# zshを再起動(exec zsh -l)した時は$ZDOTDIRの設定が残るため、このファイルは読み込まれない。
# よって、.zshenvに書く内容は~/.zsh/.zshenvに書いておく
export ZDOTDIR=${HOME}/.zsh
source ${ZDOTDIR}/.zshenv
