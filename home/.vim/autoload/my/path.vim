scriptencoding utf-8

function! my#path#buffer(mode) abort " {{{1
  if exists('b:vimfiler')
    let filename = matchstr(getline('.'), g:vimfiler_tree_closed_icon . '\?\s\+\zs\F\+')
    return b:vimfiler.current_dir . filename
  endif

  let buffer_file = expand('%')

  if buffer_file =~# '^sudo:'
    let buffer_file = matchstr(buffer_file, '^sudo:\zs.*')
  endif

  return fnamemodify(buffer_file, a:mode)
endfunction

function! my#path#buffer_dir() abort
  return my#path#buffer(':p:h')
endfunction

function! my#path#project_dir() abort " {{{1
  let project_dir = projectionist#path()

  if !empty(project_dir)
    return project_dir
  endif

  let buffer_dir = my#path#buffer_dir()

  let project_dir = vital#of('vital').import('Prelude').path2project_directory(buffer_dir, 1)

  if !empty(project_dir)
    return project_dir
  endif

  if exists('g:project_dir_pattern')
    let project_dir = matchstr(buffer_dir, g:project_dir_pattern)
  endif

  return project_dir
endfunction

function! my#path#project_relative_path(mode) abort " {{{1
  return substitute(my#path#buffer(':p' . a:mode), my#path#project_dir() . '/', '', '')
endfunction
