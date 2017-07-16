scriptencoding utf-8

if exists('g:did_ftplugin_python')
  finish
endif

let g:did_ftplugin_python = 1

call add(g:lightline['active']['left'][2], 'pyenv')

let g:lightline['component_function']['pyenv'] = 'MyPyenv'

function! MyPyenv()
  return pyenv#info#format('%ss(%iv)')
endfunction

call lightline#init()
