#!/bin/bash

PORT_1=8080
PORT_2=50000

version=${RANDOM}
TMP_PASSWORD='/var/jenkins_home/secrets/initialAdminPassword'

function increment_port(){
	port=${1}
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
	container_name=${1}
	[[ ! ${container_name} ]] && exit 1
	containers=$(docker ps --format "table {{.Names}}"|grep ${container_name})
	if [[ ${containers} ]];then
		echo 'WARNING: Jenkins container already running'
		if ! is_answer_yes "DIALOG: Do you want to recreate a Jenkins container? [y/N] ";then
        	echo "Good bye!" && exit 0
	    fi
	fi
	for i in ${containers};do
		docker kill ${i}
	done
	docker system prune -f
}

kill_running_container jenkins

docker 	run --name jenkins_${version} \
		-p $(increment_port ${PORT_1}):${PORT_1} \
		-p $(increment_port ${PORT_2}):${PORT_2} \
		-d jenkins/jenkins

sleep 2

docker ps --format "table {{.Names}}\t{{.Networks}}\t{{.Status}}\t{{.Ports}}"

echo
echo "INFO: Use url below for access to Jenkins:"
echo "http://$(wget -q -O- ifconfig.me):${PORT_1}"
echo

echo "INFO: Waiting for password..."
while ! docker exec jenkins_${version} ls ${TMP_PASSWORD} &> /dev/null;do
	sleep 2
done

echo
echo "INFO: Copy/paste password below:"
docker exec jenkins_${version} cat ${TMP_PASSWORD}
echo
