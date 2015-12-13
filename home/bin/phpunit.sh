#!/usr/bin/env bash

# original
# composer で入れた phpunit で少し楽をする - Qiita
# http://qiita.com/ngyuki/items/57ab6bb0e69590d5752d

function func_phpunit
{
    local cmd="phpunit"
    local dir="${PWD}"

    while [ -n "${dir}" ]; do
        if [ -x "${dir}/vendor/bin/phpunit" ]; then
            cmd="${dir}/vendor/bin/phpunit"
            break
        fi
        dir="${dir%/*}"
    done

    dir="${PWD}"
    while [ -n "${dir}" ]; do
        if [ -f "${dir}/phpunit.xml" ]; then
            cmd="${cmd} --configuration=${dir}/phpunit.xml"
            break
        elif [ -f "${dir}/phpunit.xml.dist" ]; then
            cmd="${cmd} --configuration=${dir}/phpunit.xml.dist"
            break
        fi
        dir="${dir%/*}"
    done

    $cmd $@ | cat
    return ${PIPESTATUS[0]}
}

func_phpunit $@
