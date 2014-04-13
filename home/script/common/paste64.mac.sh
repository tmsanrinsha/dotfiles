#!/usr/bin/env bash

# stdin=`cat -`
# str=`echo -e \`cat -\` | base64`
# echo $str
if [ "$TERM" = 'screen' ];then
    # Tmuxのとき
    printf "\x1bPtmux;\x1b\x1b]52;;%s\x1b\x1b\\\\\x1b\\" `base64 -`
    # printf "\x1bPtmux;\x1b\x1b]52;;%s\x1b\x1b\\\\\x1b\\" `echo -en \`cat -\` | base64`
    # printf "\x1bPtmux;\x1b\x1b]52;;%s\x1b\x1b\\\\\x1b\\" `echo -en $stdin | base64`
    # printf "\x1bPtmux;\x1b\x1b]52;;%s\x1b\x1b\\\\\x1b\\" echo -en $str
    # GNU Screenのとき
    # printf "\x1bP\x1b]52;;%s\x07\x1b\\" `base64 -`
else
    printf "\x1b]52;;%s\x1b\\" `base64 -`
fi
