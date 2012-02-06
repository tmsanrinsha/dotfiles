#!/bin/sh
ln -svn $HOME/git/dotfiles/.bash_profile $HOME
ln -svn $HOME/git/dotfiles/.bashrc $HOME
ln -svn $HOME/git/dotfiles/.inputrc $HOME
ln -svn $HOME/git/dotfiles/.exrc $HOME
ln -svn $HOME/git/dotfiles/.my.cnf $HOME
ln -svn $HOME/git/dotfiles/.screenrc $HOME
ln -svn $HOME/git/dotfiles/.tmux.conf $HOME
ln -svn $HOME/git/dotfiles/.vimrc $HOME
ln -svn $HOME/git/dotfiles/.zashrc $HOME
ln -svn $HOME/git/dotfiles/.zshrc $HOME
mkdir $HOME/bin
ln -svn $HOME/git/dotfiles/bin/apacheErrorColor.sed $HOME/bin
ln -svn $HOME/git/dotfiles/bin/fxg $HOME/bin
ln -svn $HOME/git/dotfiles/bin/tree.sh $HOME/bin
