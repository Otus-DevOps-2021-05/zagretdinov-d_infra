# zagretdinov-d_infra
zagretdinov-d Infra repository

## Домашнее задание

## Ansible: работа с ролями и окружениями окружения

Создайте новую ветку ansible-3.
Создал папку ansible/roles, создал в ней две роли:

ansible-galaxy init db
ansible-galaxy init app

![изображение](https://user-images.githubusercontent.com/85208391/126910536-0ffc048e-d3e7-43e7-a400-7b197fd18899.png)

db
Перенес секцию tasks из db.yml в roles/db/tasks/main.yml, при этом в src для модуля template указал только имя файла.
Перенес секцию handles из db.yml в roles/db/handles/main.yml
Перенес ansible/templates/mongod.conf.j2 в roles/app/templates/mongod.conf.j2

в db.yml подключил роль:
```
- name: Configure MongoDB
  hosts: db
  become: true

  vars:
    mongo_bind_ip: 0.0.0.0

  roles:
    - db
```
app

Перенес секцию tasks из app.yml в roles/app/tasks/main.yml, при этом в src для модулей copy и template указал только имя файла.
Перенес секцию handles из app.yml в roles/app/handles/main.yml
Перенес ansible/files/puma.service в roles/app/files/puma.service
Перенес ansible/templates/db_config.j2 в roles/app/templates/db_config.j2

в app.yml подключил роль:
```
- name: Configure App
  hosts: app
  become: true

  vars:
    db_host: 10.132.0.2

  roles:
    - app
```












