setlocal noexpandtab
setlocal nowrap
nnoremap <buffer> <silent> <F2> :let &ts=(&ts*2 > 32 ? 2 : &ts*2)<CR>:echo "tabstop:" . &ts<CR>
nnoremap <Right> f<Tab>l
nnoremap <Left> 2F<Tab>l
