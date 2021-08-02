#!/bin/bash

URL_MINIKUBE=''
URL_KUBECTL=''
URL_GITLAB_RUNNER=''
URL_HEML=''

function install_gitlab_runner(){
	curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"
	chmod +x /usr/local/bin/gitlab-runner
	mkdir /etc/gitlab-runner/ && touch /etc/gitlab-runner/config.toml
	mkdir /home/gitlab-runner
	adduser --disabled-password --gecos "" gitlab-runner --shell /bin/bash -H /home/gitlab-runner
	if apk add screen;then
		screen -dmS GITLAB_RUNNER /usr/local/bin/gitlab-runner run
		# gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
	fi
}

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

if ! apt update;then
	if ! apk update;then
		echo "WARNING: not updated"
	fi
fi

#install_gitlab_runner

#docker run -p 8080:8080 -p 50000:50000 jenkins/jenkins
