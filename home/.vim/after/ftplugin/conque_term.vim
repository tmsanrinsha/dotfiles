if exists('b:did_after_ftplugin_conque_term')
  finish
endif

let b:did_after_ftplugin_conque_term = 1

" let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . ' | ' : '')
" \ . 'setlocal list< t_SI< t_EI< | execute "autocmd! after_ftplugin_conque_term * <buffer>"'

setlocal nolist
setlocal t_SI&
setlocal t_EI&
