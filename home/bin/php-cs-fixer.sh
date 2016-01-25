#!/usr/bin/env bash

function func_php-cs-fixer
{
    local cmd=$(which php-cs-fixer 2>/dev/null)

    if [ -z "$cmd" ]; then
        echo 'command not found: php-cs-fixer'
        return 1
    fi

    cmd="${cmd} fix"
    local dir="${PWD}"

    while [ -n "${dir}" ]; do
        if [ -f "${dir}/.php_cs" ]; then
            cmd="${cmd} --config-file=${dir}/.php_cs"
            break 1
        fi
        dir="${dir%/*}"
    done

    php -d open_basedir= $cmd $@
}

func_php-cs-fixer $@
