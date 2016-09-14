#!/usr/bin/env bash

# original
# composer で入れた phpunit で少し楽をする - Qiita
# http://qiita.com/ngyuki/items/57ab6bb0e69590d5752d

function func_phpunit
{
    local cmd=$(type phpunit 2>/dev/null)
    local dir="${PWD}"

    while [ -n "${dir}" ]; do
        if [ -x "${dir}/vendor/bin/phpunit" ]; then
            cmd="${dir}/vendor/bin/phpunit"
            break
        fi
        dir="${dir%/*}"
    done

    if [ -z "$cmd" ]; then
        echo 'command not found: phpunit'
        return 1
    fi

    dir="${PWD}"
    while [ -n "${dir}" ]; do
        for testdir in "tests" "test" "" ; do
            for xml in "phpunit.xml" "phpunit.xml.dist"; do
                if [ -f "${dir}/${testdir}/${xml}" ]; then
                    cmd="${cmd} --configuration=${dir}/${testdir}/${xml}"
                    break 3
                fi
            done
        done
        dir="${dir%/*}"
    done

    php -d open_basedir= -d date.timezone=Asia/Tokyo -d apc.enable_cli=1 $cmd $@ | cat
    return ${PIPESTATUS[0]}
}

func_phpunit $@
