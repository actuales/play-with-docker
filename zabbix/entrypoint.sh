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

# RUN MYSQL
docker run --name mysql-server -t \
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
docker run --name zabbix-server-mysql -t \
      -e DB_SERVER_HOST="mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix_pwd" \
      -e MYSQL_ROOT_PASSWORD="root_pwd" \
      -e ZBX_JAVAGATEWAY="zabbix-java-gateway" \
      --link mysql-server:mysql \
      --link zabbix-java-gateway:zabbix-java-gateway \
      -p 10051:10051 \
      -d zabbix/zabbix-server-mysql:latest

# RUN ZABBIX WEB
docker run --name zabbix-web-nginx-mysql -t \
      -e DB_SERVER_HOST="mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix_pwd" \
      -e MYSQL_ROOT_PASSWORD="root_pwd" \
      --link mysql-server:mysql \
      --link zabbix-server-mysql:zabbix-server \
      -p 80:8080 \
      -d zabbix/zabbix-web-nginx-mysql:latest
