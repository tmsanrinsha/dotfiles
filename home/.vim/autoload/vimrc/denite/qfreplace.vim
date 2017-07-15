scriptencoding utf-8

function! vimrc#denite#qfreplace#action(context)
  let qflist = []
  for target in a:context['targets']
    if !has_key(target, 'action__path') | continue | endif
    if !has_key(target, 'action__line') | continue | endif
    if !has_key(target, 'action__text') | continue | endif

    call add(qflist, {
    \ 'filename': target['action__path'],
    \ 'lnum': target['action__line'],
    \ 'text': target['action__text']
    \ })
  endfor
  call setqflist(qflist)
  call qfreplace#start('')
endfunction
