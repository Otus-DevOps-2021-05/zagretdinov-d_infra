#!/bin/bash

# добавления ключей от репозитория
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -

# добавления репозиторий
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

# обновление пакетов
apt-get update

# установка mongodb
apt-get install -y mongodb-org

# запуск mongodb
systemctl start mongod

# добавление в автозапуск
systemctl enable mongod
