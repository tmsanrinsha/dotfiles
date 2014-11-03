if exists('b:did_after_ftplugin_conque_term')
  finish
endif
let b:did_after_ftplugin_conque_term = 1

let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . ' | ' : '')
\ . 'setlocal list< t_SI< t_EI< | execute "autocmd! after_ftplugin_conque_term * <buffer>"'

setlocal nolist
setlocal t_SI&
setlocal t_EI&

if neobundle#is_installed("neocomplete")
    let s:neocom_disable_auto_complete = 'g:neocomplete#disable_auto_complete'
elseif neobundle#is_installed("neocomplcache")
    let s:neocom_disable_auto_complete = 'g:neocomplcache_disable_auto_complete'
else
    finish
endif

augroup after_ftplugin_conque_term
    autocmd! * <buffer>
    autocmd BufEnter <buffer> execute 'let ' . s:neocom_disable_auto_complete . ' = 1'
    autocmd BufLeave <buffer> execute 'let ' . s:neocom_disable_auto_complete . ' = 0'
augroup END
