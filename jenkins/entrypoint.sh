#!/bin/bash

set -e

PORT_1=8080
PORT_2=50000

VERSION=${RANDOM}

function increment_port(){
	port=${1}
	[[ ! ${port} ]] && exit 1
	while ss -lnp|grep :${port} &> /dev/null;do
		port=$(( port+1 ))
	done
	echo ${port}
}

docker 	run --name jenkins_${VERSION} \
		-p $(increment_port ${PORT_1}):${PORT_1} \
		-p $(increment_port ${PORT_2}):${PORT_2} \
		-d jenkins/jenkins
