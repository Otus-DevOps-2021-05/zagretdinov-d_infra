#!/bin/bash

wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
apt-get install apt-transport-https ca-certificates
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
apt-get update
apt-get install -y mongodb-org
systemctl enable mongod
systemctl start mongod
