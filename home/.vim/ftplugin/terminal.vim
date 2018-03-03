scriptencoding utf-8

setlocal nonumber
setlocal foldcolumn=0

" PROMPTに飛ぶ
nnoremap <silent><buffer> [[ m':call search('^' . $USER . '@', "bW")<CR>
vnoremap <silent><buffer> [[ m':<C-U>exe "normal! gv"<Bar>call search('^' . $USER . '@', "bW")<CR>
nnoremap <silent><buffer> ]] m':call search('^' . $USER . '@', "W")<CR>
vnoremap <silent><buffer> ]] m':<C-U>exe "normal! gv"<Bar>call search('^' . $USER . '@', "W")<CR>
