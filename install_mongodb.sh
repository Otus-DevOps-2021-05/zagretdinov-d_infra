#!/bin/bash
# добаление ключей для репозитория и сертификатов
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
apt-get install apt-transport-https ca-certificates
# добаление репозитория
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
# обновление пакетов
apt-get update
# установка mongodb
apt-get install -y mongodb-org
# добавления в автозапуск
systemctl enable mongod
# старт mongodb
systemctl start mongod
