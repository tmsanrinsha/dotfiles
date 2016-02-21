#!/usr/bin/env bash
col -b -x | \
$EDITOR -c 'setlocal ft=man nonumber nomod nomodifiable nolist' \
        -c 'noremap <buffer> q :q<CR>' \
        -c 'nnoremap <buffer> K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -
