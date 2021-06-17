#!/bin/bash
#update the system
echo "####################################"
echo "update the system"
echo "####################################"
sudo yum update -y
#upgrade the system
echo "####################################"
echo "upgrade the system"
echo "####################################"
sudo yum upgrade -y
# disable selinux/config
echo "####################################"
echo"disable SElinux (Security Enhanced Linux)"
"echo "####################################""
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config
#download en install mariadb
echo "####################################"
echo "download en install MariaDB"
echo "####################################"
wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
cat <<EOF | sudo tee /etc/yum.repos.d/MariaDB.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.5/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
sudo yum makecache fast
sudo yum -y install MariaDB-server MariaDB-client
sudo systemctl enable --now mariadb
#set bind-address mysql-server to 0.0.0.0 (accept queries from all hosts)
echo "####################################"
echo "set bind-address mysql-server to 0.0.0.0 (accept queries from all hosts)"
echo "####################################"
sudo sed -i 's/#bind-address=0.0.0.0/bind-address=0.0.0.0/g' /etc/my.cnf.d/server.cnf
#create database nextcloud and user admin with password nextcloud
echo "####################################"
echo "create database nextcloud and user admin with apssword nextcloud"
echo "####################################"
sudo mysql -e "CREATE DATABASE nextcloud;"
sudo mysql -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'nextcloud';"
sudo mysql -e "GRANT ALL PRIVILEGES ON nextcloud.*  TO 'admin'@'%' WITH GRANT OPTION;"
sudo mysql -e "FLUSH PRIVILEGES;"
# start mysql deamon
echo "####################################"
echo "start mysql deamon"
echo "####################################"
sudo systemctl restart mysqld
# cleanup iptables firewall
echo "####################################"
echo "cleanup iptables firewall"
echo "####################################"
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
