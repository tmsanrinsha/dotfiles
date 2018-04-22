scriptencoding utf-8

if isdirectory(expand('~/AppData/Local/Android/android-sdk/sources/android-17'))
  setlocal path+=~/AppData/Local/Android/android-sdk/sources/android-17
elseif isdirectory(expand('/Program Files (x86)/Android/android-sdk/sources/android-17'))
  setlocal path+=/Program\ Files\ (x86)/Android/android-sdk/sources/android-17
endif

setlocal foldmethod=syntax
nnoremap <buffer>  [[ [m
nnoremap <buffer>  ]] ]m
