#!/bin/bash

echo "---- update package list ----"
apt-get update
apt-get -y --fix-broken install

echo "---- setting up postgresql ----"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/postgresql-pgdg.list > /dev/null
apt-get update
apt-get install -y postgresql-14
sudo -u postgres psql <<EOF
CREATE ROLE developer WITH LOGIN PASSWORD 'password' SUPERUSER CREATEDB CREATEROLE INHERIT;
CREATE DATABASE developer;
GRANT ALL PRIVILEGES ON DATABASE developer TO developer;
EOF
echo "configuring remote access to PostgreSQL..."
cat <<EOF | sudo tee -a /etc/postgresql/14/main/postgresql.conf
#
# Custom settings
#
listen_addresses = '*'
EOF
cat <<EOF | sudo tee -a /etc/postgresql/14/main/pg_hba.conf
#
# Custom settings
#
host    all             all             0.0.0.0/0            md5
EOF
service postgresql restart

echo "---- install nodejs ----"
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs
npm install pm2 -g

echo "---- setting up docker ----"
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

echo "---- setting up nginx ----"
apt-get install -y nginx
bash /vagrant_scripts/configure_nginx.sh
nginx -s reload
ufw allow 80
