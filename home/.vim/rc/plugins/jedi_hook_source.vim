scriptencoding utf-8

" call s:set_python_path()

autocmd MyVimrc FileType python setlocal omnifunc=jedi#completions

if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif

" iexe pythonで>>>がある場合も補完が効くように
" '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" を ^\s* -> ^>*\s* に変更した
let g:neocomplete#force_omni_input_patterns.python =
\ '\%([^. \t]\.\|^>*\s*@\|^>*\s*from\s.\+import \|^>*\s*from \|^>*\s*import \)\w*'

let g:jedi#completions_enabled = 0
" completeopt, <C-c>の変更をしない
let g:jedi#auto_vim_configuration = 0

" quickrunと被るため大文字に変更
let g:jedi#rename_command = '<Leader>R'
let g:jedi#goto_assignments_command = '<C-]>'

if jedi#init_python()
    function! s:jedi_auto_force_py_version() abort
        let major_version = pyenv#python#get_internal_major_version()
        call jedi#force_py_version(major_version)
    endfunction
    augroup vim-pyenv-custom-augroup
        autocmd! *
        autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
        autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
    augroup END
endif
