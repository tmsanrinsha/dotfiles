scriptencoding utf-8

" Hugo {{{1
" ============================================================================
function! my#create_hugo_shortcode_img(url) abort
  return system('identify -format ''{{< img src="' . a:url . '" w="%w" h="%h" >}}'' <(curl -s "' . a:url . '")')
endfunction

" Other {{{1
" ============================================================================
" %s@\v\[(.*)\]\s*(.{-})\s*\[/\1\]@`\2`@gc
" %s@\v\[(.*)\]\s*(.{-})\s*\[/\1\]@\='`' . my#entity2char(submatch(2)) . '`'@gc

function! my#entity2char(str)
  let str = substitute(a:str, '&#\(\d\+\);', '\=nr2char(submatch(1))', 'g')
  " let str = substitute(a:str, '&#\(\d\+\);', '\1', 'g')
  return str
endfunction
