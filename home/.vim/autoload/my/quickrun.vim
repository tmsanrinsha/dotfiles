scriptencoding utf-8

function! my#quickrun#run(mode) abort range
  try
    bwipeout quickrun:
  catch /E94/
  endtry

  let cf = context_filetype#get()

  if cf['filetype'] != &filetype
    let start = a:mode == 'n' ? cf['range'][0][0] : a:firstline
    let end   = a:mode == 'n' ? cf['range'][1][0] : a:lastline
    execute start . ',' . end . 'QuickRun -type '  . cf['filetype']
  else
    execute 'QuickRun -mode ' . a:mode
  endif
endfunction
