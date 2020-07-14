#!/bin/bash -e

# const strings
TARGET_SETUP_DIR="$HOME/temporary_env_setup_files"
INSTALL_SCRIPT_FILE="install.sh"
CUSTOM_BASH_PROFILE="bash_profile_custom"
CUSTOM_BASH_ALIASES="bash_aliases_custom"
CURRENT_DIR=$(pwd)


# This script works by having custom alias and profile files
# It assumes these custom files DONT exist on the target system
# So it will copy these files over any existing custom files. Update.
# Then it searches the bashrc and profile files for sourcing these custom files
# And appends sourceing them if it's not already added to bashrc


function checkEnvSetupFilesDirAndPrint() {
    printf "Running script in: '%s'\n" $CURRENT_DIR

    if [[ ! -d $TARGET_SETUP_DIR ]]; then
        printf "Bootstrap script must already have been run, to get install.sh and files into %s\n" $TARGET_SETUP_DIR
        exit 1
    else
        printf "Pulling environment setup files from : %s\n\nFiles:\n" $TARGET_SETUP_DIR
        for file in "$TARGET_SETUP_DIR"/*
        do
            printf "  - %s\n" $file
        done
    fi
}

function setupCustomBashInitFiles() {
    echo
    set -x
    cp $TARGET_SETUP_DIR/$CUSTOM_BASH_PROFILE $HOME/.$CUSTOM_BASH_PROFILE
    cp $TARGET_SETUP_DIR/$CUSTOM_BASH_ALIASES $HOME/.$CUSTOM_BASH_ALIASES
    set +x

    BASH_PROFILE_FILE="$HOME/.bashrc"
    printf "\nUsing bash profile file: [%s]\n" $BASH_PROFILE_FILE

    BASH_ALIASES_FILE="$HOME/.bash_aliases"
    printf "Using bash aliases file: [%s]\n\n" $BASH_ALIASES_FILE

    if ! grep -Eqs "$CUSTOM_BASH_PROFILE" "$BASH_PROFILE_FILE"; then
        printf "adding profile to %s\n" $BASH_PROFILE_FILE
        printf '\n\n# Source custom bash profile\n' >> $BASH_PROFILE_FILE
        printf '. ~/.%s\n' $CUSTOM_BASH_PROFILE >> $BASH_PROFILE_FILE
    fi

    if ! grep -Eqs "$CUSTOM_BASH_ALIASES" "$BASH_ALIASES_FILE" 2>&1 > /dev/null; then
        printf "adding aliases to %s\n" $BASH_ALIASES_FILE
        printf '\n\n# Source custom bash aliases\n' >> $BASH_ALIASES_FILE
        printf '. ~/.%s\n' $CUSTOM_BASH_ALIASES >> $BASH_ALIASES_FILE
    fi
}

function verifyBashRCFileIsSourced() {
    FOUND_BASHRC_SOURCING=false
    if grep -Eqs .bashrc "$HOME/.bash_profile"; then
      FOUND_BASHRC_SOURCING=true
    fi
    if grep -Eqs ".bashrc" "$HOME/.profile"; then
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
        printf "##############################################\n\n"
    fi
}

function finishup() {
    printf "\nMove tmux howto into ~/docs\n"
    printf "DELETE the env setup temp files:\n"
    printf "\n  rm -rf %s\n" $TARGET_SETUP_DIR
    printf '\nYou should source your bashrc.\nRun:\n  source %s\n\n' $BASH_PROFILE_FILE
}

# first check that the env setup files dir exists, and bootstrap already ran
checkEnvSetupFilesDirAndPrint

# then setup custom bash files
setupCustomBashInitFiles

# verify .bashrc is sourced
verifyBashRCFileIsSourced

# call finishup func
finishup