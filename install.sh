#!/bin/bash

echo test
could which git, and if git is installed, clone the repo, otherwise wget list of fils
echo wget some short url or list of urls
echo move downloaded file to .bash_custom_profile
echo if statement that will source custom profile if it exists, into .bashrc
echo search the bashrc for sourcing bash_aliases, if it exists, just move aliases file, otherwise append sourcing aliases file 

echo grep -E bash_custom_profile ~/.bashrc  => if doesnt exist, append to file
printf "source \"\$HOME/.bash_custom_profile\"\n" 
source "$HOME/.bashrc" # source the file just in case
