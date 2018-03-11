scriptencoding utf-8

if exists("b:my_did_ftplugin") | finish | endif
let b:my_did_ftplugin = 1

" :compiler pythonでセットされるerrorformatだとTracebackが表示されないので修正
setlocal errorformat+=%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%m


" lightlineにpyenvのバージョンを設定する {{{1
" ============================================================================
" pythonのファイルを最初に呼び出したタイミングで一回やればいいので、
" グローバルな変数g:did_ftplugin_pythonを定義
if exists('g:did_ftplugin_python')
  finish
endif

let g:did_ftplugin_python = 1

if exists('*pyenv#info#format')
  call add(g:lightline['active']['left'][2], 'pyenv')
  let g:lightline['component_function']['pyenv'] = 'MyPyenv'
  call lightline#init()
endif

function! MyPyenv()
  return pyenv#info#format('%ss(%iv)')
endfunction
