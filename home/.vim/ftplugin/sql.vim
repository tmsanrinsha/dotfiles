scriptencoding utf-8

if exists('b:did_my_ftplugin_sql')
  finish
endif
let b:did_my_ftplugin_sql = 1

let g:sql_type_default = 'mysql'
" ]}, [{ の移動先
let g:ftplugin_sql_statements = 'create,alter'

setlocal formatprg=sql-formatter
