#!/usr/bin/env bash

# .gitの更新時刻でソートされたghqのディレクトリを取得する
# .gitがない場合は更新時刻を0とする

ghq_roots="$(git config --path --get-all ghq.root)"

for dir in $(ghq list --full-path)
do
    # echo $dir
    if [ -d "$dir/.git" ]; then
        ls -dl --time-style=+%s "$dir/.git" | sed 's/.*\([0-9]\{10\}\)/\1/' | sed 's/\/.git//'
    else
        echo 0 "$dir"
    fi
done | sort -nr | sed "s,.*\(${ghq_roots//$'\n'/\\|}\)/,,"
