#! /bin/bash
 
set -e
set -x
 
hostnamectl --static set-hostname "ipaserver.domain.local"
SERVER_IP_ADDR=192.168.56.101
SERVER_FQDN=`hostname`
SERVER_NAME=`hostname | cut -d. -f 1 | tr '[:upper:]' '[:lower:]'`
IPA_REALM=DOMAIN.LOCAL
IPA_DOMAIN=domain.local
FORWARDER=10.0.2.3
PASSWORD=aaaAAA111
