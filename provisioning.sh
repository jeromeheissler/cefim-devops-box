#!/bin/bash

wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list

apt-get update
apt-get install -y default-jdk curl openssh-server ca-certificates
apt-get install -y jenkins maven docker.io docker-compose mysql-server

usermod -a -G docker jenkins
usermod -a -G docker vagrant

systemctl start jenkins
systemctl start docker
systemctl enable docker

ufw allow 8080


