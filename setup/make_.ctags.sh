#!/bin/sh

cat <<EOT
--tag-relative
--recurse=yes
--exclude=.svn
--exclude=.git
--langmap=C:+.mq4
EOT

# PHP {{{1
# ============================================================================
if [ $1 == '--old' ]; then
    cat <<EOT
--php-kinds=cidfv
--langmap=PHP:+.inc.tpl
--regex-php=/^[ \t]*const[ \t]+([a-z0-9_]+)/\1/d/i
--regex-php=/^[ \t]*abstract class ([^ ]*)/\1/c/
--regex-php=/^[ \t]*interface ([^ ]*)/\1/c/
--regex-php=/^[ \t]*(public |static |abstract |protected |private )+function ([^ (]*)/\2/f/
EOT
elif [ $1 == '--new' ]; then
    cat <<EOT
--fields=+aimS
EOT
fi

# JavaSctipt {{{1
# ============================================================================
# Using ctags on modern Javascript
# http://raygrasso.com/posts/2015/04/using-ctags-on-modern-javascript.html
cat <<EOT
--languages=-javascript
--langdef=js
--langmap=js:.js
--langmap=js:+.jsx
EOT

#
# Constants
#

# A constant: AAA0_123 = { or AAA0_123: {
cat <<EOT
--regex-js=/[ \t.]([A-Z][A-Z0-9._$]+)[ \t]*[=:][ \t]*([0-9"'\[\{]|null)/\1/n,constant/
EOT

#
# Properties
#

# .name = {
cat <<EOT
--regex-js=/\.([A-Za-z0-9._$]+)[ \t]*=[ \t]*\{/\1/o,object/
EOT

# "name": {
cat <<EOT
--regex-js=/['"]*([A-Za-z0-9_$]+)['"]*[ \t]*:[ \t]*\{/\1/o,object/
EOT

# parent["name"] = {
cat <<EOT
--regex-js=/([A-Za-z0-9._$]+)\[["']([A-Za-z0-9_$]+)["']\][ \t]*=[ \t]*\{/\1\.\2/o,object/
EOT

#
# Classes
#

# name = (function()
# --regex-js=/([A-Za-z0-9._$]+)[ \t]*=[ \t]*\(function\(\)/\1/c,class/

# "name": (function()
cat <<EOT
--regex-js=/['"]*([A-Za-z0-9_$]+)['"]*:[ \t]*\(function\(\)/\1/c,class/
EOT

# class ClassName
cat <<EOT
--regex-js=/class[ \t]+([A-Za-z0-9._$]+)[ \t]*/\1/c,class/
EOT

# ClassName = React.createClass
cat <<EOT
--regex-js=/([A-Za-z$][A-Za-z0-9_$()]+)[ \t]*=[ \t]*[Rr]eact.createClass[ \t]*\(/\1/c,class/
EOT

# Capitalised object: Name = whatever({
# --regex-js=/([A-Z][A-Za-z0-9_$]+)[ \t]*=[ \t]*[A-Za-z0-9_$]*[ \t]*[{(]/\1/c,class/

# Capitalised object: Name: whatever({
cat <<EOT
--regex-js=/([A-Z][A-Za-z0-9_$]+)[ \t]*:[ \t]*[A-Za-z0-9_$]*[ \t]*[{(]/\1/c,class/
EOT

#
# Functions
#

# name = function(
# .も含める
cat <<EOT
--regex-js=/([A-Za-z$][A-Za-z0-9_$.]+)[ \t]*=[ \t]*function[ \t]*\(/\1/f,function/
EOT

#
# Methods
#

# Class method or function (this matches too many things which I filter out separtely)
# name() {
# --regex-js=/(function)*[ \t]*([A-Za-z$_][A-Za-z0-9_$]+)[ \t]*\([^)]*\)[ \t]*\{/\2/f,function/

# "name": function(
cat <<EOT
--regex-js=/['"]*([A-Za-z$][A-Za-z0-9_$]+)['"]*:[ \t]*function[ \t]*\(/\1/m,method/
EOT

# parent["name"] = function(
cat <<EOT
--regex-js=/([A-Za-z0-9_$]+)\[["']([A-Za-z0-9_$]+)["']\][ \t]*=[ \t]*function[ \t]*\(/\2/m,method/
EOT

# Vim script {{{1
# ============================================================================
cat <<EOT
--regex-vim=/\*([^*]+)\*/\1/k/
EOT
