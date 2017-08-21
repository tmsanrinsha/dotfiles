scriptencoding utf-8

call denite#custom#option('default', 'prompt', '>')

call denite#custom#action('file', 'qfreplace', 'vimrc#denite#qfreplace#action')

call denite#custom#map('insert', '<Esc>', '<denite:enter_mode:normal>', 'noremap')
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('normal', 'R', '<denite:do_action:qfreplace>', 'noremap')
call denite#custom#map('normal', 'Q', '<denite:do_action:quickfix>', 'noremap')

" grep {{{1
" ============================================================================
if executable('ag')
  call denite#custom#var('grep', 'command', ['ag'])
  call denite#custom#var('grep', 'default_opts',
  \ ['-i', '--vimgrep'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
endif
