# if [ -d ~/.profile.d ]; then
#     for i in ~/.profile.d/*.sh ; do
#         if [ -r "$i" ]; then
#             if [ "${-#*i}" != "$-" ]; then
#                 . $i
#             else
#                 . "$i" >/dev/null 2>&1
#             fi
#         fi
#     done
# fi
#
# if [ -f ~/.sh/logout_local.sh ];then
#     . ~/.sh/logout_local.sh
# fi

# vim:filetype=sh
