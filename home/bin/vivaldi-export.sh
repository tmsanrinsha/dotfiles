#!/bin/sh
backup_list=$(cat << EOS
Preferences
Local App Settings
EOS
)
echo "$backup_list"                 |
sed "s;^;$HOME/Library/Application\ Support/Vivaldi/Default/;" |
tr '\n' '\0'                        |
xargs -0 zip -r vivaldi-$(date +%Y%m%d_%H%M%S).zip
