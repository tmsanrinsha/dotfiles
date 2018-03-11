scriptencoding utf-8

" Alternate {{{1
" ============================================================================
function! my#alternate()
  return projectionist#query('alternate')[0][1]
endfunction

" Hugo {{{1
" ============================================================================
" Hugo用Markdownのリンクを返す
" [<title>]({{< ref "<path>" >}})
function! my#hugo_ref(fname) abort
  for line in readfile(a:fname)
    if line =~ '^title:'
      let title = matchstr(line, '^title:\s*\zs.*$')
      break
    endif
  endfor
  let path = matchstr(a:fname, '/content/\zs.*$')
  return '[' . title . ' - SanRin舎]({{< ref "' . path . '" >}})'
endfunction

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
