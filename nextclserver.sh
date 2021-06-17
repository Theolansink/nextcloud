#!/bin/bash
echo "####################################"
echo "update the system"
echo "####################################"
sudo yum update -y
echo "####################################"
echo "upgrade the system"
echo "####################################"
sudo yum upgrade -y
echo "####################################"
echo"disable SElinux (Security Enhanced Linux)"
"echo "####################################""
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config
echo "#####################################"
echo "install php and webserver httpd"
echo "#####################################"
sudo yum -y install epel-release yum-utils
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --disable remi-php54
sudo yum-config-manager --enable remi-php73
sudo yum -y install vim httpd php php-cli php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json php-pdo php-pecl-apcu php-pecl-apcu-devel
wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
echo "####################################"
echo "download en install MariaDB client for testing connection to remote database"
echo "####################################"
cat <<EOF | sudo tee /etc/yum.repos.d/MariaDB.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.5/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
sudo yum makecache fast
# install mariadb client to test connection to remote database
sudo yum -y install MariaDB-client
# Nextcloud
echo "####################################"
echo "download en install nextcloud"
echo "####################################"
sudo yum -y install wget unzip
wget https://download.nextcloud.com/server/releases/latest-20.zip
unzip latest-20.zip
rm -f latest-20.zip
sudo mv nextcloud/ /var/www/html/
sudo mkdir /var/www/html/nextcloud/data
sudo chown apache:apache -R /var/www/html/nextcloud/data
sudo chown apache:apache -R /var/www/html/nextcloud
echo "####################################"
echo "start and enable webserver"
echo "####################################"
sudo systemctl enable --now httpd
sudo systemctl restart httpd
