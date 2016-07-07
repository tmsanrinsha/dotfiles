scriptencoding utf-8

setlocal tabstop=2
let &l:softtabstop = &l:tabstop
let &l:shiftwidth = &l:tabstop

" Set async completion.
let g:monster#completion#rcodetools#backend = 'async_rct_complete'

" With deoplete.nvim
let g:monster#completion#rcodetools#backend = 'async_rct_complete'

