#!/bin/bash -e

echo Bootstrap script must already have been run, to get install.sh and files

# This script works by having custom alias and profile files
# It assumes these custom files DONT exist on the target system
# So it will copy these files over any existing custom files. Update.
# Then it searches the bashrc and profile files for sourcing these custom files
# And appends sourceing them if it's not already added to bashrc

CURRENT_DIR=$(pwd)
printf "Running script in: '%s'\n" $CURRENT_DIR
printf "Pulling environment setup files from list:\n\n%s\n\n" "$(ls $CURRENT_DIR)"

CUSTOM_BASH_PROFILE="bash_profile_custom"
CUSTOM_BASH_ALIASES="bash_aliases_custom"

set -x
cp $CURRENT_DIR/$CUSTOM_BASH_PROFILE $HOME/.$CUSTOM_BASH_PROFILE
cp $CURRENT_DIR/$CUSTOM_BASH_ALIASES $HOME/.$CUSTOM_BASH_ALIASES
set +x

BASH_PROFILE_FILE="$HOME/.bashrc"
printf "\nUsing bash profile file: [%s]\n" $BASH_PROFILE_FILE

BASH_ALIASES_FILE="$HOME/.bash_aliases"
printf "Using bash aliases file: [%s]\n" $BASH_ALIASES_FILE

if ! grep -Eq "$CUSTOM_BASH_PROFILE" "$BASH_PROFILE_FILE"; then
    printf "adding profile to %s\n" $BASH_PROFILE_FILE
    printf '\n\n# Source custom bash profile\n' >> $BASH_PROFILE_FILE
    printf 'source %s/.%s\n' $HOME $CUSTOM_BASH_PROFILE >> $BASH_PROFILE_FILE
fi

if ! grep -Eq "$CUSTOM_BASH_ALIASES" "$BASH_ALIASES_FILE"; then
    printf "adding aliases to %s\n" $BASH_ALIASES_FILE
    printf '\n\n# Source custom bash aliases\n' >> $BASH_ALIASES_FILE
    printf 'source %s/.%s\n' $HOME $CUSTOM_BASH_ALIASES >> $BASH_ALIASES_FILE
fi

function finishup() {
    printf "\n also move tmux howto into ~/docs\n"
    printf '\nYou should source your bashrc.\nRun:\n  source %s\n\n' $BASH_PROFILE_FILE
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