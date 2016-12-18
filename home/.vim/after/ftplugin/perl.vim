scriptencoding utf-8
setlocal errorformat+=%m\ at\ %f\ line\ %l\.

" https://github.com/vim-perl/vim-perl/pull/129
setlocal errorformat=
    \%-G%.%#had\ compilation\ errors.,
    \%-G%.%#syntax\ OK,
    \%m\ at\ %f\ line\ %l.,
    \%+A%.%#\ at\ %f\ line\ %l\\,%.%#,
    \%+C%.%#

" Explanation:
" %-G%.%#had\ compilation\ errors.,  - Ignore the obvious.
" %-G%.%#syntax\ OK,                 - Don't include the 'a-okay' message.
" %m\ at\ %f\ line\ %l.,             - Most errors...
" %+A%.%#\ at\ %f\ line\ %l\\,%.%#,  - As above, including ', near ...'
" %+C%.%#                            -   ... Which can be multi-line.
