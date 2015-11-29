#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc vim Xresources emacs"    # list of files/folders to symlink in homedir

##########

# Verification of the install dir
if [[ ! "$(cd `dirname $0` && pwd)" == "$dir" ]]; then
  echo "The dotfiles repo is at a wrong place. It should be at $dir"
  exit 1
fi

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    if [ -f ~/.$file -o -d ~/.$file ]; then # check if file or directory exists
        echo "moved $file"
        mv -f ~/.$file $olddir
    fi

    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

