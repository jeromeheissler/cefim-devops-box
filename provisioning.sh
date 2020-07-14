#!/bin/bash
DBHOST=localhost
DBNAME=petclinic
DBUSER=root
DBPASSWD=root

wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list

apt-get update
apt-get install -y default-jdk curl openssh-server ca-certificates
apt-get install -y jenkins maven docker.io docker-compose

usermod -a -G docker jenkins
usermod -a -G docker vagrant

systemctl start jenkins
systemctl start docker
systemctl enable docker

ufw allow 8080

debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"

# install mysql and admin interface

apt-get -y install mysql-server

mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME"
mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'%' identified by '$DBPASSWD'"
# update mysql conf file to allow remote access to the db

sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

sudo service mysql restart