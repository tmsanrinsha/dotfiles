if exists('b:did_my_after_ftplugin_yaml')
  finish
endif
let b:did_my_after_ftplugin_yaml = 1

setlocal foldmethod=expr foldexpr=fold#indent(v:lnum) softtabstop=2 shiftwidth=2
nnoremap <buffer> [unite]o<CR> :<C-u>Unite outline:folding<CR>
