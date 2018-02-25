scriptencoding utf-8

function! my#shogi#start()

  let shogiban = [
  \ '９８７６５４３２１',
  \ '香桂銀金王金銀桂香一',
  \ '　飛　　　　　角　二',
  \ '歩歩歩歩歩歩歩歩歩三',
  \ '　　　　　　　　　四',
  \ '　　　　　　　　　五',
  \ '　　　　　　　　　六',
  \ '歩歩歩歩歩歩歩歩歩七',
  \ '　角　　　　　飛　八',
  \ '香桂銀金玉金銀桂香九',
  \]

  new
  call setline(1, shogiban)

  nnoremap <buffer> <M-k>    vyr　kvp
  nnoremap <buffer> <M-l> vyr　lvp
  nnoremap <buffer> <M-j>  vyr　jvp
  nnoremap <buffer> <M-h>  vyr　hvp
endfunction

