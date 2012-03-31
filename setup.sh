#!/bin/sh

GITPATH=$HOME/git/my_git/dotfiles
ln -svn $GITPATH/.bash_logout $HOME
ln -svn $GITPATH/.bash_profile $HOME
ln -svn $GITPATH/.bashrc $HOME
ln -svn $GITPATH/.inputrc $HOME
ln -svn $GITPATH/.exrc $HOME
ln -svn $GITPATH/.my.cnf $HOME
ln -svn $GITPATH/.screenrc $HOME
ln -svn $GITPATH/.tmux.conf $HOME
ln -svn $GITPATH/.vimrc $HOME
ln -svn $GITPATH/.zash_logout $HOME
ln -svn $GITPATH/.zash_logout.local $HOME
ln -svn $GITPATH/.zashrc $HOME
ln -svn $GITPATH/.zashrc.local $HOME
ln -svn $GITPATH/.zlogout $HOME
ln -svn $GITPATH/.zshrc $HOME
mkdir $HOME/script
ln -svn $GITPATH/script/apacheErrorColor.sed $HOME/script
ln -svn $GITPATH/script/decomp.sh $HOME/script
ln -svn $GITPATH/script/fxg.sh $HOME/script
ln -svn $GITPATH/script/tree.sh $HOME/script

# http://betterthangrep.com/
curl http://betterthangrep.com/ack-standalone > ~/local/bin/ack && chmod 0755 !#:3 
