#!/bin/bash

PORT_1=8080       # port for web
PORT_2=10051      # port for service

CONTAINER_NAME='zabbix'

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

# RUN MYSQL
docker run --name zabbix-mysql-server -t \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix_pwd" \
      -e MYSQL_ROOT_PASSWORD="root_pwd" \
      -d mysql:5.7 \
      --character-set-server=utf8 --collation-server=utf8_bin

# RUN JAVA GATEWAY
docker run --name zabbix-java-gateway -t \
      -d zabbix/zabbix-java-gateway:latest

# RUN ZABBIX SERVER
PORT_2=$(increment_port ${PORT_2})
docker run --name zabbix-server-mysql -t \
      -e DB_SERVER_HOST="zabbix-mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix_pwd" \
      -e MYSQL_ROOT_PASSWORD="root_pwd" \
      -e ZBX_JAVAGATEWAY="zabbix-java-gateway" \
      --link zabbix-mysql-server:mysql \
      --link zabbix-java-gateway:zabbix-java-gateway \
      -p ${PORT_2}:10051 \
      -d zabbix/zabbix-server-mysql:latest

# RUN ZABBIX WEB
PORT_1=$(increment_port ${PORT_1})
docker run --name zabbix-web-nginx-mysql -t \
      -e DB_SERVER_HOST="zabbix-mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix_pwd" \
      -e MYSQL_ROOT_PASSWORD="root_pwd" \
      --link zabbix-mysql-server:mysql \
      --link zabbix-server-mysql:zabbix-server \
      -p ${PORT_1}:8080 \
      -d zabbix/zabbix-web-nginx-mysql:latest

sleep 2

docker ps --format "table {{.Names}}\t{{.Networks}}\t{{.Status}}\t{{.Ports}}"

echo
echo "INFO: Use url below for access to ${CONTAINER_NAME}:"
echo "http://$(wget -q -O- ifconfig.me):${PORT_1}"
echo
