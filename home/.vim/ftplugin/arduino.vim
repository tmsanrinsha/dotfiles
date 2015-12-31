if exists('b:did_my_ftplugin_arduino')
  finish
endif
let b:did_my_ftplugin_arduino = 1

setlocal path+=~/Dropbox/src/localhost/me/Arduino/libraries/*
setlocal commentstring=//%s
