if [[ `hostname` == *ua.sakura.ne.jp ]]; then
    # ssh-pageant
    if [ -x /usr/bin/ssh-pageant -a -n "$SSH_PAGEANT_PID" ]; then
        eval $(/usr/bin/ssh-pageant -qk 2>/dev/null)
    elif command_exists ssh-agent && [ -n "$SSH_AGENT_PID" ]; then
        TTNUM=`ps | awk '{if (NR != 1) print $2}' | sort | uniq | wc -l`
        if [ $TTNUM -eq 1 ]; then
            eval $(/usr/bin/ssh-agent -qk 2>/dev/null)
        fi
    fi
fi

if [ -f ~/.sh/logout_local.sh ]; then
    . ~/.sh/logout_local.sh
fi

# vim:filetype=sh
