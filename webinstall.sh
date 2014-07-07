#!/bin/sh

# Install script for SOTA syntax highlighting in VIM
set -e
set -u

# Installation will put two files in place under $INSTALLDIR
# syntax/sota.vim == highlighting
# ftdetect/sota.vim == filetype detection
SOURCE=https://raw.github.com/mjwade/vim-syntax-sota/master
INSTALLDIR=$HOME/.vim

echo -e "Installing vim-syntax-simics"

# Create the needed paths and files
echo -e "\t-Making subdirs in $HOME/.vim"
mkdir -p $INSTALLDIR/syntax/
if [ $? -ne 0 ]; then #failed
    EXITCODE=$?
    echo "failed to mkdir -p on $INSTALLDIR/syntax/sota.vim"
    exit $EXITCODE
fi
mkdir -p $INSTALLDIR/ftdetect/
if [ $? -ne 0 ]; then #failed
    EXITCODE=$?
    echo "failed to mkdir -p on $INSTALLDIR/ftdetect/sota.vim"
    exit $EXITCODE
fi

# Fill the files 
# NOTE: Assumes you're running this from the web...
echo -e "\t-Fetching the vim-sota files from the web"
curl --raw --silent $SOURCE/syntax/sota.vim > $INSTALLDIR/syntax/sota.vim
curl --raw --silent $SOURCE/ftdetect/sota.vim > $INSTALLDIR/ftdetect/sota.vim

# Stuff should be in the files now...
echo "Installation is complete.  Enjoy!"
