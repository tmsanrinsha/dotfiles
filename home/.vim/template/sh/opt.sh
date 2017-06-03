progname=$(basename $0)

usage() {
  cat <<EOT
Usage: $progname [OPTIONS] FILE

Options:
  -h, --help
  -n, --dry-run
EOT

    exit 1
}

for OPT in "$@"
do
    case "$OPT" in
        '-h'|'--help' )
            exit 1
            ;;
        '-n'|'--dry-run' )
            dryrun=1
            ;;
        '--'|'-' )
            shift 1
            param+=( "$@" )
            break
            ;;
        -*)
            echo "$progname: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
            exit 1
            ;;
        *)
            if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
                param+=( "$1" )
                shift 1
            fi
            ;;
    esac
done

if [ -z $param ]; then
    echo "$progname: too few arguments" 1>&2
    echo "Try '$progname --help' for more information." 1>&2
    exit 1
fi
