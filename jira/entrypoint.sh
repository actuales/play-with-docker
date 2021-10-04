#!/bin/bash

PORT_1=8080 	# port for web
PORT_2=50000 	# port for service

CONTAINER_NAME='jenkins'
IMAGE_NAME='jenkins/jenkins'
TMP_PASSWORD='/var/jenkins_home/secrets/initialAdminPassword'

function increment_port(){
	local port=${1}
	[[ ! ${port} ]] && exit 1
	while ss -lnp|grep :${port} &> /dev/null;do
		port=$(( port+1 ))
	done
	echo ${port}
}

function is_answer_yes(){
    local message="${1}"
    echo -n "${message}"
    read answer
    [[ "${answer}" =~ ^[Yy]$ ]] && return 0 || return 1
}

function kill_running_container(){
	local container_name=${1}
	[[ ! ${container_name} ]] && exit 1
	local containers=$(docker ps --format "table {{.Names}}"|grep ${container_name})
	if [[ ${containers} ]];then
		echo "WARNING: ${CONTAINER_NAME} container already running"
		if ! is_answer_yes "DIALOG: Do you want to recreate a ${CONTAINER_NAME} container? [y/N] ";then
        	echo "Good bye!" && exit 0
	    fi
	fi
	for container in ${containers};do
		docker kill ${container}
	done
	docker system prune -f
}

kill_running_container ${CONTAINER_NAME}

docker-compose up -d
sleep 2

docker ps --format "table {{.Names}}\t{{.Networks}}\t{{.Status}}\t{{.Ports}}"

echo
echo "INFO: Use url below for access to ${CONTAINER_NAME}:"
echo "http://$(wget -q -O- ifconfig.me):${PORT_1}"
echo

echo "INFO: Waiting for password..."
while ! docker exec ${CONTAINER_NAME} ls ${TMP_PASSWORD} &> /dev/null;do
	sleep 2
done

echo
echo "INFO: Copy/paste password below:"
docker exec ${CONTAINER_NAME} cat ${TMP_PASSWORD}
echo
