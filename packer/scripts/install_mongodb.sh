#!/bin/sh
wget -qO - https://www.mongodb.org/static/pgp/server-3.2.asc | sudo apt-key add -
#apt-get install apt-transport-https ca-certificates
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
apt-get update
apt-get install -y mongodb-org
systemctl start mongod
systemctl enable mongod
