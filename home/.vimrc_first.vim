scriptencoding utf-8
" Macの場合はKaoriya Vimの設定を読まない
if has('kaoriya') && has('mac')
  let g:vimrc_first_finish = 1
endif
