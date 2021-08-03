#!/bin/bash

set -e

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

function kill_running_jenkins(){
	jenkins_containers=$(docker ps --format "table {{.Names}}"|grep jenkins)
	for i in ${jenkins_containers};do
		docker kill ${i}
	done
	docker system prune -f
}

if ! kill_running_jenkins;then
	echo 'not running jenkins'
fi

docker 	run --name jenkins_${version} \
		-p $(increment_port ${PORT_1}):${PORT_1} \
		-p $(increment_port ${PORT_2}):${PORT_2} \
		-d jenkins/jenkins

sleep 2

docker ps --format "table {{.Names}}\t{{.Networks}}\t{{.Status}}\t{{.Ports}}"

echo
echo "Use url below for access to Jenkins:"
echo "http://$(wget -q -O- ifconfig.me):${PORT_1}"
echo

echo "Waiting for password..."
while ! docker exec jenkins_${version} ls ${TMP_PASSWORD} &> /dev/null;do
	sleep 2
done

echo
echo "Copy/paste password below:"
docker exec jenkins_${version} cat ${TMP_PASSWORD}
echo
