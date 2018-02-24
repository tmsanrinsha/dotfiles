scriptencoding utf-8

function! vimrc#denite#action#vimfiler(context)
  execute 'VimFiler ' . a:context.targets[0].action__path
endfunction
