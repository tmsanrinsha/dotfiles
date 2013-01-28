#!/usr/bin/env bash
set -ex

test -d ~/bin || mkdir ~/bin
curl -L http://xrl.us/cpanm > ~/bin/cpanm
chmod +x ~/bin/cpanm
export PERL5LIB="${HOME}/perl5/lib/perl5:$PERL5LIB"
test -d ~/.cpanm || mkdir ~/.cpanm
cpanm --local-lib=~/perl5 local::lib
test -d ~/.profile.d || mkdir ~/.profile.d
echo 'export PERL5LIB="${HOME}/perl5/lib/perl5:$PERL5LIB"' > ~/.profile.d/cpanm.sh
echo 'eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)'    >> ~/.profile.d/cpanm.sh
source ~/.profile.d/cpanm.sh
