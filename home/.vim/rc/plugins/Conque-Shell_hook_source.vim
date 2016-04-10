scriptencoding utf-8

" 違うバッファに移ってもバッファを更新し続ける。
" ただし、スクロールはできない
let g:ConqueTerm_ReadUnfocused = 1
" プログラムが終了したらバッファを閉じる
let g:ConqueTerm_CloseOnEnd = 1
" 設定がまずい場合は立ち上げ時にwarningを出す
let g:ConqueTerm_StartMessages = 1
" <C-w>をウィンドウを変更するために使わない(ConqueTerm上で<C-w>を使う)
let g:ConqueTerm_CWInsert = 0
" 通常の<Esc>はconqueTermにEscapeを送って、<C-j>はVimにEscapeを送る
let g:ConqueTerm_EscKey = '<C-j>'

" [もぷろぐ: Vim から zsh を呼ぶ ﾌﾟﾗｷﾞﾝ 紹介](http://ac-mopp.blogspot.jp/2013/02/vim-zsh.html)
" bufferが消えた時プロセスを終了する。なくてもいい気がする
" function! s:delete_ConqueTerm(buffer_name)
"     let term_obj = conque_term#get_instance(a:buffer_name)
"     call term_obj.close()
" endfunction
" autocmd! my_conque BufWinLeave zsh\s-\s? call <SID>delete_ConqueTerm(expand('%'))
