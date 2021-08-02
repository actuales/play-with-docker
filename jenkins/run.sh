#!/bin/bash

ENTRYPOINT_FILE="entrypoint.sh"
DOCKER_COMPOSE_FILE="docker-compose.yml"

if [[ ! ${1} ]];then
	echo "USAGE: $(basename $0) <HOSTNAME or IP>"
	exit 1
fi

host_name=${1}

if ! ssh ${host_name} "ls -la"|grep ${ENTRYPOINT_FILE} &> /dev/null;then
	scp {${ENTRYPOINT_FILE},${DOCKER_COMPOSE_FILE}} ${host_name}:
	ssh ${host_name} "./${ENTRYPOINT_FILE}"
fi
