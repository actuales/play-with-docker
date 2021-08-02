#!/bin/bash

function prepare_profile(){
	cat <<EOF > ${HOME}/.profile
WHITE='\[\033[0m\]'
GREEN='\[\033[1;32m\]'
PURPURE='\[\033[1;35m\]'
YELLOW='\[\033[1;33m\]'
RED='\[\033[0;31m\]'
BLUE='\[\033[1;34m\]'
CYAN='\[\033[0;36m\]'
PS1="\${CYAN}[\u]\${BLUE}@\${CYAN}[\h]\${BLUE}[\W]\${WHITE}\${CYAN}\\$\${WHITE} "
alias ll='ls -la'

EOF
}

####################  __MAIN__  ####################

set -e

cd ${HOME}

prepare_profile

docker-compose up -d