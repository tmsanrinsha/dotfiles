scriptencoding utf-8

call denite#custom#option('_', 'prompt', '>')

hi DeniteMatchedRange cterm=underline gui=underline
call denite#custom#option('_', 'highlight_matched_range', 'DeniteMatchedRange')
call denite#custom#option('_', 'highlight_mode_normal', 'CursorLine')
call denite#custom#option('_', 'highlight_mode_normal', 'CursorLine')

call denite#custom#action('file', 'qfreplace', 'vimrc#denite#qfreplace#action')

call denite#custom#action('directory', 'debug', {context -> execute('PP! context', '')})
call denite#custom#action('directory', 'vimfiler', 'vimrc#denite#action#vimfiler')

" Denite directory_rec -default_action=vimfilerを常にしたいが、デフォルトのactionをオプションで指定はできないらしい。
" call denite#custom#option('directory', 'default_action', 'vimfiler')
" 第一引数はbuffer-nameを指定する必要があるため、これだとうまくいかない


call denite#custom#map('insert', '<Esc>', '<denite:enter_mode:normal>',     'noremap')
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>',     'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('normal', 'R',     '<denite:do_action:qfreplace>',   'noremap')
call denite#custom#map('normal', 'Q',     '<denite:do_action:quickfix>',    'noremap')
call denite#custom#map('normal', '<Esc>', '<denite:quit>',                  'noremap')

" file {{{1
" ============================================================================
if executable('ag')
  call denite#custom#var('file_rec', 'command',
  \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif

" grep {{{1
" ============================================================================
if executable('ag')
  call denite#custom#var('grep', 'command', ['ag'])
  call denite#custom#var('grep', 'default_opts',
  \ ['-iS', '--vimgrep', '--hidden'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
endif
