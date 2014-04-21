if exists('b:did_ftplugin_vimwiki')
  finish
endif
let b:did_ftplugin_vimwiki = 1

nmap <buffer> ]l <Plug>VimwikiNextLink
