scriptencoding utf-8

nmap <buffer> \\ <Plug>(vimfiler_switch_to_root_directory)

" if IsInstalled('denite.nvim')
"   nmap <buffer> gf :<C-u>Denite file_rec:`GetBufferDir()`<CR>
"   nmap <buffer> gr :<C-u>Denite grep:`GetBufferDir()`<CR>
" endif
