scriptencoding utf-8

let g:go_fmt_command = 'goimports'

let g:go_metalinter_autosave = 1
" let g:go_metalinter_autosave_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_autosave_enabled = ['vet']

setlocal errorformat-=%-G%.%#

nmap <buffer> <Leader>a<CR> <Plug>(go-alternate-edit)
nmap <buffer> <Leader>as    <Plug>(go-alternate-split)
nmap <buffer> <Leader>av    <Plug>(go-alternate-vertical)
nmap <buffer> <Leader>at    :call go#alternate#Switch(<bang>0, 'tabe')<CR>

nmap <buffer> <Leader>c <Plug>(go-coverage-toggle)
nmap <buffer> <Leader>i <Plug>(go-info)

inoremap <buffer> <M-i> <C-o>:GoImport <C-r><C-w><CR>

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

nmap <buffer> <leader>b :<C-u>call <SID>build_go_files()<CR>
