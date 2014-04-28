function! unite#sources#outline#conf#outline_info()
  return s:outline_info
endfunction

"-----------------------------------------------------------------------------
" Outline Info

let s:outline_info = {
      \ 'heading+1': '\s*#\s*[-=]\{4,}$',
      \ }

function! s:outline_info.create_heading(which, heading_line, matched_line, context)
  let heading = {
        \ 'word' : a:heading_line,
        \ 'level': 0,
        \ 'type' : 'generic',
        \ }

  if a:which ==# 'heading+1'
    if a:matched_line =~ '='
      let heading.level = 1
    else
      let heading.level = 2
    endif
  endif

  if heading.level > 0
    return heading
  else
    return {}
  endif
endfunction
