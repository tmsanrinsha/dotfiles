#!/usr/bin/env bash
PATH="/Applications/MacVim.app/Contents/MacOS:/usr/local/bin:/usr/bin:$PATH"

if ! ctags --version | grep 'Exuberant Ctags' 1>/dev/null 2>&1; then
    echo 'Exuberant Ctags is not found'
    exit
fi

progname=$(basename $0)

usage() {
  cat <<EOT
Usage: $progname -d dir [arg]

Options:
  -h, --help  Print this option summary.
  -d          directory
EOT

    exit 1
}

for OPT in "$@"
do
  case "$OPT" in
    '-h'|'--help' )
      usage
      exit 1
      ;;
    '-d' )
      if [ -z "$2" ]; then
        usage
        exit 1
      fi
      FLAG_D=1
      dir="$2"
      shift 2
      ;;
    *)
      param+=( "$1" )
      shift 1
      ;;
  esac
done

if [ "$FLAG_D" != 1 ]; then
  usage
fi

test -d ${dir} || mkdir -p ${dir}

# filetypeごとにファイルを作る
for filetype in $(ctags --list-languages | grep -v disabled | tr A-Z a-z); do
  ctags -f "${dir}/${filetype}.tags" --languages="${filetype}" ${param[@]}
done
