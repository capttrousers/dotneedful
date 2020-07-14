#!/bin/bash

TARGET_SETUP_DIR="$HOME/temporary_env_setup_files"
printf "target setup dir to bootstrap files into: %s\n" $TARGET_SETUP_DIR

if ! git --version 2>&1 >/dev/null; then 
  printf "Git not installed, exiting...\n"
  exit 1;  
fi

if [[ -d $TARGET_SETUP_DIR ]]; then
    printf "target setup directory already exists\n"
    printf "get the latest from git repo, then rerun install.sh\n"
    exit 1;
else 
    git clone https://github.com/capttrousers/dotneedful.git $TARGET_SETUP_DIR
fi

printf "\n  Then run %s/install.sh\n" $TARGET_SETUP_DIR