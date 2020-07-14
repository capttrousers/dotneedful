#!/bin/bash

TARGET_SETUP_DIR="$HOME/temporary_env_setup_files"
printf "target setup dir to bootstrap files into: %s\n" $TARGET_SETUP_DIR

if [[ -d $TARGET_SETUP_DIR ]]; then
    printf "target setup directory already exists\n"
    exit 1;
fi

if git --version 2>&1 >/dev/null; then 
    git clone https://github.com/capttrousers/dotneedful.git $TARGET_SETUP_DIR
else 
    wget -q https://github.com/capttrousers/dotneedful/archive/master.zip
    unzip -q master.zip -d $TARGET_SETUP_DIR
fi 

# echo for now, bootstrapping will just be copying the files from local repo
# mkdir -p $TARGET_SETUP_DIR
# cp -a $HOME/code/dotneedful/* $TARGET_SETUP_DIR

printf "\n  Then run %s/install.sh\n" $TARGET_SETUP_DIR