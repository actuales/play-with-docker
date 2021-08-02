#!/bin/bash

ENTRYPOINT_FILE="entrypoint.sh"

service_name=${1}
host_name=${2}

if [[ ! ${service_name} || ! ${host_name} ]];then
	echo "USAGE: $(basename $0) <SERVICE> <URL_FOR_SSH>"
	exit 1
fi

scp ${service_name}/* ${host_name}:

ssh ${host_name} "./${ENTRYPOINT_FILE}"
