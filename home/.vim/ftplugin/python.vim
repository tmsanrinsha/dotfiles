scriptencoding utf-8

if exists("b:my_did_ftplugin") | finish | endif
let b:my_did_ftplugin = 1

compiler pyunit

" lightlineにpyenvのバージョンを設定する {{{1
" ============================================================================
" pythonのファイルを最初に呼び出したタイミングで一回やればいいので、
" グローバルな変数g:did_ftplugin_pythonを定義
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
