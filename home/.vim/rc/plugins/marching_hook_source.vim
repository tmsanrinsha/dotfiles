scriptencoding utf-8

" clang コマンドの設定
let g:marching_clang_command = "clang"

" オプションを追加する
" filetype=cpp に対して設定する場合
" let g:marching#clang_command#options = {
" \   "cpp" : "-std=gnu++1y"
" \}

function! s:getCPath()
    if ! exists('g:c_path')
        let g:c_path = substitute(
        \   system("gcc -print-search-dirs | awk -F= '/libraries/ {print $2}'")
        \   , "\<NL>", '', ''
        \) . '/include'
    endif
    return g:c_path
endfunction

" インクルードディレクトリのパスを設定
let g:marching_include_paths = [
\   s:getCPath()
\]

" neocomplete.vim と併用して使用する場合
let g:marching_enable_neocomplete = 1

if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif

let g:neocomplete#force_omni_input_patterns.cpp =
\ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

" オムニ補完時に補完ワードを挿入したくない場合
" imap <buffer> <C-x><C-o> <Plug>(marching_start_omni_complete)

" キャッシュを削除してからオムに補完を行う
imap <buffer> <C-x><C-x><C-o> <Plug>(marching_force_start_omni_complete)
