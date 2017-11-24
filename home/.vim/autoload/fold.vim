function! fold#indent(lnum)
  if getline(a:lnum) =~? '\v^\s*$'
    return '-1'
  endif
  return '>' . (indent(a:lnum) / &shiftwidth + 1)
endfunction

function! fold#text(foldstart)
 let [_, indent, text; _] = matchlist(getline(a:foldstart), '^\([\t\s]*\)\(.*\)')
 let width = strdisplaywidth(indent)
 return repeat(' ', width) . text . repeat(' ', winwidth(''))
endfunction
