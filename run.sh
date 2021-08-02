#!/bin/bash

ENTRYPOINT_FILE="entrypoint.sh"

service_name=${1}
host_name=${2}

### Check args:
if [[ ! ${service_name} || ! ${host_name} ]];then
	echo "USAGE: $(basename $0) <SERVICE> <URL_FOR_SSH>"
	exit 1
fi

### Copy all service files to remote server:
scp ${service_name}/* ${host_name}:

### Execute bash script on a remote server:
ssh ${host_name} "./${ENTRYPOINT_FILE}"
