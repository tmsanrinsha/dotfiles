if exists('b:did_ftplugin_xml')
  finish
endif

if executable('xmllint')
    setlocal formatprg=xmllint\ --format\ --encode\ utf-8\ -
else
    nnoremap <buffer> gq :%s/></>\r</ge<CR>gg=G
    xnoremap <buffer> gq  :s/></>\r</ge<CR>gg=G
endif
