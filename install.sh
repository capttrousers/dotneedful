#!/bin/bash -e

# This script works by having custom alias and profile files
# It assumes these custom files DONT exist on the target system
# So it will copy these files over any existing custom files. Update.
# Then it searches the bashrc and profile files for sourcing these custom files
# And appends sourceing them if it's not already added to bashrc

CURRENT_DIR=$(pwd)
printf "Running script in: [%s]\n" $CURRENT_DIR
SETUP_ENV_DIR="setup_env"
if [[ "$CURRENT_DIR" =~ "$SETUP_ENV_DIR" ]]; then
 printf "Cannot run script in the existing setup_env dir.\nExiting.\n\n"
 exit 0
fi
TARGET_SETUP_FILE_DIR="$CURRENT_DIR/"
printf "Putting environment setup files in: [%s]\n" $TARGET_SETUP_FILE_DIR

echo could which git, and if git is installed, clone the repo, otherwise wget list of fils
echo wget some short url or list of urls

CUSTOM_BASH_PROFILE="bash_profile_custom"
CUSTOM_BASH_ALIASES="bash_aliases_custom"

set -x
cp $TARGET_SETUP_FILE_DIR/$CUSTOM_BASH_PROFILE $HOME/.$CUSTOM_BASH_PROFILE
cp $TARGET_SETUP_FILE_DIR/$CUSTOM_BASH_ALIASES $HOME/.$CUSTOM_BASH_ALIASES
set +x

BASH_RC_FILE="$HOME/.bashrc"
printf "\n Using bashrc file: [%s]\n" $BASH_RC_FILE

if ! grep -Eq "$CUSTOM_BASH_PROFILE" "$HOME/.bashrc"; then
    printf '\n\n# Source custom bash profile\n' >> $BASH_RC_FILE
    printf 'source %s/.%s\n' $HOME $CUSTOM_BASH_PROFILE >> $BASH_RC_FILE
fi

if ! grep -Eq "$CUSTOM_BASH_ALIASES" "$HOME/.bashrc"; then
    printf '\n\n# Source custom bash aliases\n' >> $BASH_RC_FILE
    printf 'source %s/.%s\n' $HOME $CUSTOM_BASH_ALIASES >> $BASH_RC_FILE
fi

function finishup() {
    printf "\n also move tmux howto into ~/docs\n"
    printf '\nYou should source your bashrc.\nRun:\n  source %s\n\n' $BASH_RC_FILE
}



FOUND_BASHRC_SOURCING=false
if grep -Eq .bashrc "$HOME/.bash_profile"; then
  FOUND_BASHRC_SOURCING=true
fi
if grep -Eq ".bashrc" "$HOME/.profile"; then
  FOUND_BASHRC_SOURCING=true
fi
bar_line=
if ! $FOUND_BASHRC_SOURCING; then
    printf "##############################################\n"
    printf "  Searched .bash_profile and .profile\n"
    printf "    for '.bashrc' and it was NOT found.\n"
    printf "##############################################\n"
    printf "!!!!!!!!\n  print a warning to check\n!!!!!!!!\n\n"
else 
    printf "##############################################\n"
    printf "  Searched .bash_profile and .profile\n"
    printf "    for '.bashrc' and it was found.\n"
    printf "##############################################\n"
fi


# call finishup func
finishup