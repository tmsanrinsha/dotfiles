if exists('b:did_my_ftplugin_xml')
  finish
endif
let b:did_my_ftplugin_xml = 1

if executable('xmllint')
    setlocal formatprg=xmllint\ --format\ --encode\ utf-8\ -
else
    nnoremap <buffer> gq :%s/></>\r</ge<CR>gg=G
    xnoremap <buffer> gq  :s/></>\r</ge<CR>gg=G
endif
