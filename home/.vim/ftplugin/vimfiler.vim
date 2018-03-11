scriptencoding utf-8

nmap <buffer> \\ <Plug>(vimfiler_switch_to_root_directory)

" if IsInstalled('denite.nvim')
"   nmap <buffer> gf :<C-u>Denite file_rec:`my#path#buffer_dir()`<CR>
"   nmap <buffer> gr :<C-u>Denite grep:`my#path#buffer_dir()`<CR>
" endif
