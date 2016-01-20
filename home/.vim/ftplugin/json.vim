scriptencoding utf-8

if exists('b:did_my_ftplugin_json')
  finish
endif
let b:did_my_ftplugin_json = 1

setlocal formatexpr=
setlocal formatprg=jq\ .
" [Vim (with python) で json を整形 - Qiita](http://qiita.com/tomoemon/items/cc29b414a63e08cd4f89#comment-77832dedb32996ec7080)
command! FormatJson
\   :execute '%!python -m json.tool'
\|  :execute '%!python -c "import re,sys;chr=__builtins__.__dict__.get(\"unichr\", chr);sys.stdout.write(re.sub(r\"\\\\u[0-9a-f]{4}\", lambda x: chr(int(\"0x\" + x.group(0)[2:], 16)).encode(\"utf-8\"), sys.stdin.read()))"'
