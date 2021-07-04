#!/bin/bash
DEBIAN_FRONTEND=noninteractive apt-get install -y git
# копирование кода приложения
git clone -b monolith https://github.com/express42/reddit.git
# установка зависимостей
cd reddit && bundle install
# запуск приложения
mv /tmp/tech.service /etc/systemd/system/tech.service
chown root:root /etc/systemd/system/app.service
systemctl daemon-reload
systemctl start tech.service
systemctl enable tech.service
systemctl status tech.service
