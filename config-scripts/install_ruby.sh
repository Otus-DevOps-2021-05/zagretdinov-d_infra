#!/bin/bash

# обновляем пакеты
apt update

# установка git
apt install git

# установка ruby и bundler
apt install -y ruby-full ruby-bundler build-essential
