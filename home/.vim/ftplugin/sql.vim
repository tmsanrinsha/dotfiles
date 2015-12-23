scriptencoding utf-8

if exists('b:did_ftplugin_sql')
  finish
endif

let g:sql_type_default = 'mysql'
" ]}, [{ の移動先
let g:ftplugin_sql_statements = 'create,alter'

setlocal formatprg=sql-formatter
