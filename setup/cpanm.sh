#!/usr/bin/env bash
set -ex

test -f ~/bin || mkdir ~/bin
cd ~/bin
curl -LOk http://xrl.us/cpanm
chmod +x cpanm

cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
