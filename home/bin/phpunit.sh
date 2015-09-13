#!/usr/bin/env bash

# composer で入れた phpunit で少し楽をする - Qiita
# http://qiita.com/ngyuki/items/57ab6bb0e69590d5752d

function func_phpunit
{
    local root="${PWD}"

    while [ -n "${root}" ]; do
        if [ -x "${root}/vendor/bin/phpunit" ]; then
            break
        fi
        root="${root%/*}"
    done

    if [ -z "${root}" ]; then
        command phpunit "$@"
        return $?
    fi

    local cmd=("${root}/vendor/bin/phpunit")

    local dir xml

    for dir in "/tests/" "/" ; do
        for xml in "phpunit.xml.dist" "phpunit.xml"; do
            if [ -e "${root}${dir}${xml}" ]; then
                cmd=("${cmd[@]}" "--configuration=${root}${dir}")
                break 2
            fi
        done
    done

    cmd=("${cmd[@]}")

    "${cmd[@]}" "$@" | cat
    return ${PIPESTATUS[0]}
}

func_phpunit $@
