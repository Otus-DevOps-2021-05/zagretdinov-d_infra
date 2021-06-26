#!/bin/bash
# копирование кода приложения
git clone -b monolith https://github.com/express42/reddit.git
# установка зависимостей
cd reddit && bundle install
# запуск приложения
puma -d
