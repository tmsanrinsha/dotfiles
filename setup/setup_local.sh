#!/usr/bin/env bash
set -ex

cd "$(dirname "${BASH_SOURCE:-$0}")"

source setup.sh

cd "$(dirname "${BASH_SOURCE:-$0}")"

~/bin/vim_plugin_install.sh

crontab crontab.conf
