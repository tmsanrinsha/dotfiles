scriptencoding utf-8

nmap <buffer> \\ <Plug>(vimfiler_switch_to_root_directory)
nmap <buffer> gf :<C-u>Denite file_rec:`GetBufferDir()`<CR>
