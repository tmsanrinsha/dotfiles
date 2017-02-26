scriptencoding utf-8

if (exists("b:did_after_ftplugin"))
  finish
endif

let b:did_after_ftplugin = 1

" $VIM/runtime/ftplugin/gitrebase.vim
nnoremap <buffer> <silent> <LocalLeader>p :Pick<CR>
nnoremap <buffer> <silent> <LocalLeader>s :Squash<CR>
nnoremap <buffer> <silent> <LocalLeader>e :Edit<CR>
nnoremap <buffer> <silent> <LocalLeader>r :Reword<CR>
nnoremap <buffer> <silent> <LocalLeader>f :Fixup<CR>
nnoremap <buffer> <silent> <LocalLeader>c :Reword<CR>
