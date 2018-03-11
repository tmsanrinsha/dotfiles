scriptencoding utf-8

if IsInstalled('vim-javacomplete2')
  function! s:dot(arg)
    return '.'
  endfunction

  inoremap <buffer> . <C-r>=<SID>dot(javacomplete#imports#Add(1))<CR>
endif
