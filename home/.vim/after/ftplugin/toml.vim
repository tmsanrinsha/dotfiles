scriptencoding utf-8

setlocal keywordprg=:help
setlocal iskeyword+=#
nnoremap <buffer> [unite]o<CR> :<C-U>Unite outline:folding<CR>
