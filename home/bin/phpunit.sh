#!/usr/bin/env bash

# original
# composer で入れた phpunit で少し楽をする - Qiita
# http://qiita.com/ngyuki/items/57ab6bb0e69590d5752d

function func_phpunit
{
    local cmd='phpunit'
    local dir="${PWD}"

    while [ -n "${dir}" ]; do
        if [ -x "${dir}/vendor/bin/phpunit" ]; then
            cmd="${dir}/vendor/bin/phpunit"
            break
        fi
        dir="${dir%/*}"
    done

    if [ -z "$cmd" ]; then
        return 1
    fi

    dir="${PWD}"
    while [ -n "${dir}" ]; do
        for testdir in "tests" "test" "" ; do
            for xml in "phpunit.xml.dist" "phpunit.xml"; do
                if [ -f "${dir}/${testdir}/${xml}" ]; then
                    cmd="${cmd} --configuration=${dir}/${testdir}/${xml}"
                    break 2
                fi
            done
        done
        dir="${dir%/*}"
    done

    $cmd $@
    return ${PIPESTATUS[0]}
}

func_phpunit $@
