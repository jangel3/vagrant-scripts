#! /bin/bash
 
set -e
set -x
 
echo "Exporting env variables"
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/config.sh
 
echo "Configuring /etc/hosts ..."
echo "127.0.0.1 localhost localhost.localdomain.local localhost4 localhost4.localdomain4" > /etc/hosts
echo "::1   localhost localhost.localdomain.local localhost6 localhost6.localdomain6" >> /etc/hosts
echo "$SERVER_IP_ADDR    $SERVER_FQDN $SERVER_NAME" >> /etc/hosts

echo "Configuring /etc/sysconfig/network ..."
echo "NETWORKING=yes" >> /etc/sysconfig/network
echo "HOSTNAME=$SERVER_FQDN" >> /etc/sysconfig/network
echo "GATEWAY=$FORWARDER" >> /etc/sysconfig/network
 
echo "Configuring /etc/resolv.conf"
echo "search $IPA_DOMAIN" > /etc/resolv.conf
echo "nameserver $SERVER_IP_ADDR" >> /etc/resolv.conf
echo "nameserver $FORWARDER" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
 
echo "Downloading IPA rpms ..."
yum install -y freeipa-server bind bind-dyndb-ldap
 
echo "Configuring firewalld ..."
firewall-cmd --permanent --zone=public --add-port  80/tcp
firewall-cmd --permanent --zone=public --add-port 443/tcp
firewall-cmd --permanent --zone=public --add-port 389/tcp
firewall-cmd --permanent --zone=public --add-port 636/tcp
firewall-cmd --permanent --zone=public --add-port  88/tcp
firewall-cmd --permanent --zone=public --add-port 464/tcp
firewall-cmd --permanent --zone=public --add-port  53/tcp
firewall-cmd --permanent --zone=public --add-port  88/udp
firewall-cmd --permanent --zone=public --add-port 464/udp
firewall-cmd --permanent --zone=public --add-port  53/udp
firewall-cmd --permanent --zone=public --add-port 123/udp
 
firewall-cmd --zone=public --add-port  80/tcp
firewall-cmd --zone=public --add-port 443/tcp
firewall-cmd --zone=public --add-port 389/tcp
firewall-cmd --zone=public --add-port 636/tcp
firewall-cmd --zone=public --add-port  88/tcp
firewall-cmd --zone=public --add-port 464/tcp
firewall-cmd --zone=public --add-port  53/tcp
firewall-cmd --zone=public --add-port  88/udp
firewall-cmd --zone=public --add-port 464/udp
firewall-cmd --zone=public --add-port  53/udp
firewall-cmd --zone=public --add-port 123/udp

firewall-cmd --set-default-zone=public

mv /etc/sysconfig/network-scripts/ifcfg-enp0s3 /etc/sysconfig/network-scripts/enp0s3 # Somehow the initial ifcfg is wrong.  Just deactivate it
systemctl start network
ip addr add $SERVER_IP_ADDR/24 dev enp0s8 # Add ip address.
 
echo "Installing IPA server ..."
ipa-server-install --setup-dns --forwarder=8.8.8.8 -r $IPA_REALM --hostname=$SERVER_FQDN -n $IPA_DOMAIN -a $PASSWORD -p $PASSWORD -U

echo "Testing kinit"
echo $PASSWORD | kinit admin
