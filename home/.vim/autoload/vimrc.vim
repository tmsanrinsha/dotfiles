scriptencoding utf-8

" Alternate {{{1
" ============================================================================
function! vimrc#alternate()
  return projectionist#query('alternate')[0][1]
endfunction

function! vimrc#full_path() abort
  if exists('b:vimfiler') && match(b:vimfiler.current_dir, '/static/')
    let l:dirname = matchstr(b:vimfiler.current_dir, 'static/\zs.*')
    let l:filename = matchstr(getline('.'), g:vimfiler_tree_closed_icon . '\?\s\+\zs\F\+')
    return l:dirname . l:filename
  endif
  return expand('%:p')
endfunction




" Hugo {{{1
" ============================================================================
function! vimrc#create_hugo_shortcode_img(url) abort
  return system('identify -format ''{{< img src="' . a:url . '" w="%w" h="%h" >}}'' <(curl -s "' . a:url . '")')
endfunction

" Other {{{1
" ============================================================================
" %s@\v\[(.*)\]\s*(.{-})\s*\[/\1\]@`\2`@gc
" %s@\v\[(.*)\]\s*(.{-})\s*\[/\1\]@\='`' . vimrc#entity2char(submatch(2)) . '`'@gc

function! vimrc#entity2char(str)
  let str = substitute(a:str, '&#\(\d\+\);', '\=nr2char(submatch(1))', 'g')
  " let str = substitute(a:str, '&#\(\d\+\);', '\1', 'g')
  return str
endfunction
