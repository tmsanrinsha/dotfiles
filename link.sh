#!/bin/sh
ln -svn $HOME/git/my_git/dotfiles/.bash_profile $HOME
ln -svn $HOME/git/my_git/dotfiles/.bashrc $HOME
ln -svn $HOME/git/my_git/dotfiles/.inputrc $HOME
ln -svn $HOME/git/my_git/dotfiles/.exrc $HOME
ln -svn $HOME/git/my_git/dotfiles/.my.cnf $HOME
ln -svn $HOME/git/my_git/dotfiles/.screenrc $HOME
ln -svn $HOME/git/my_git/dotfiles/.tmux.conf $HOME
ln -svn $HOME/git/my_git/dotfiles/.vimrc $HOME
ln -svn $HOME/git/my_git/dotfiles/.zashrc $HOME
ln -svn $HOME/git/my_git/dotfiles/.zashrc.local $HOME
ln -svn $HOME/git/my_git/dotfiles/.zshrc $HOME
mkdir $HOME/bin
ln -svn $HOME/git/my_git/dotfiles/bin/apacheErrorColor.sed $HOME/bin
ln -svn $HOME/git/my_git/dotfiles/bin/fxg.sh $HOME/bin
ln -svn $HOME/git/my_git/dotfiles/bin/tree.sh $HOME/bin
