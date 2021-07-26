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
    db_host: 192.168.10.6

  roles:
    - app
```
## Проверка ролей

Пересоздаю инфра структуру.
```
$ terraform destroy
$ terraform apply -auto-approve=false
```
![изображение](https://user-images.githubusercontent.com/85208391/126911458-78e69867-2e9f-4e58-b7c1-50449d0a377a.png)

$ ansible-playbook site.yml --check
$ ansible-playbook site.yml

![изображение](https://user-images.githubusercontent.com/85208391/126912639-fec6c75e-d347-4088-8835-f7e74dffbad2.png)

Проверяю работу приложения


![изображение](https://user-images.githubusercontent.com/85208391/126912745-78cbcfef-48db-4163-a522-b36dac6dac6f.png)

## Окружения

Создал папки
```
ansible/environments
ansible/environments/prod
ansible/environments/stage
```

Положил в prod и stage файл inventory, из корневой папки ansible удалил inventory.

Теперь, когда у нас два инвентори файла, то чтобы управлять хостами окружения нам необходимо явно передавать команде, какой инвентори мы хотим использовать. Например, чтобы задеплоить приложение на prod окружении мы должны теперь написать:

ansible-playbook -i environments/prod/inventory deploy.yml

Определил окружение по умолчанию в ansible.cfg

inventory = ./environments/stage/inventory # Inventory по-умолчанию задается здесь

Директория group_vars, созданная в директории плейбука или инвентори файла, позволяет создавать файлы (имена, которых должны соответствовать названиям групп в инвентори файле) для определения переменных для группы хостов.

Создал директорию group_vars в environments/prod и environments/stage.

Создал в stage/group_vars/all:

env: stage

Создал в stage/group_vars/app:

db_host: 10.132.0.2

Создал в stage/group_vars/db:

mongo_bind_ip: 0.0.0.0

Для prod все аналогично, только в group_vars/all:

env: prod

В roles/app/defaults/main.yml и roles/db/defaults/main.yml добавил:

env: local

Добавил в roles/app/tasks/main.yml и roles/db/tasks/main.yml таск выводящий текущее окружение:

```
- name: Show info about the env this host belongs to
  debug:
    msg: "This host is in {{ env }} environment!!!"
```

Навел порядок в директории ansible

Перенес плейбуки в папку playbooks
Перенес files, templates, inventory.sh и inventory.yml в папку old

Улучшил ansible.cfg
```
[defaults]
inventory = ./environments/stage/inventory
remote_user = ubuntu
private_key_file = ~/.ssh/zagretdinov
host_key_checking = False
retry_files_enabled = False
roles_path = ./roles
vault_password_file = ~/.ansible/vault.key

[diff]
always = True
context = 5
```
## Настройка stage окружения

![изображение](https://user-images.githubusercontent.com/85208391/126913497-c71108dc-ffa0-4453-b013-da00e576434c.png)

![изображение](https://user-images.githubusercontent.com/85208391/126913515-8478dc3a-71bf-46a5-bdef-60e804ec44a9.png)

## Настройка Prod окружения

![изображение](https://user-images.githubusercontent.com/85208391/126913622-8e09dfd5-6b73-4db2-9bf1-262ed4c5758b.png)

![изображение](https://user-images.githubusercontent.com/85208391/126913627-5d1eba47-c995-4566-877d-2110b5a480e2.png)

## Работа с community-ролями

Коммьюнити-роли в основном находятся на портале Ansible Galaxy и работа с ними производится с помощью утилиты ansible-galaxy и файла requirements.yml

Используем роль jdauphant.nginx и настроим обратное проксирование для нашего приложения с помощью nginx.

Хорошей практикой считается разделение зависимостей ролей по окружениям. Создал файлы environments/stage/requirements.yml и environments/prod/requirements.yml, с содержимым:
```
- src: jdauphant.nginx
  version: v2.21.1
```
Установил роль:

ansible-galaxy install -r environments/stage/requirements.yml

![изображение](https://user-images.githubusercontent.com/85208391/126914428-62d2f9ab-377b-46c7-a2b9-135a56ca63c4.png)

Коммьюнити-роли не стоит коммитить в свой репозиторий, поэтому добавил исклюение в .gitignore

jdauphant.nginx

Добавил переменные для роли в stage/group_vars/app и prod/group_vars/app:
```
nginx_sites:
  default:
    - listen 80
    - server_name "reddit"
    - location / {
        proxy_pass http://127.0.0.1:9292;
      }
```

Добавил в terraform/modules/app/main.tf 80 порт:
```
resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["9292", "80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-app"]
}
```
Добавил вызов роли jdauphant.nginx в плейбук app.yml

## Работа с Ansible Vaul

Для безопасной работы с приватными данными (пароли, приватные ключи и т.д.) используется механизм Ansible Vault. Данные сохраняются в зашифрованных файлах, которые при выполнении плейбука автоматически расшифровываются. Таким образом, приватные данные можно хранить в системе контроля версий.

Для шифрования используется мастер-пароль (aka vault key). Его нужно передавать команде ansible-playbook при запуске, либо указать файл с ключом в ansible.cfg. Не допускайте хранения этого ключ-файла в Git! Используйте для разных окружений разный vault key.

Подготовим плейбук для создания пользователей, пароль пользователей будем хранить в зашифрованном виде в файле credentials.yml:

- Создал файл vault.key с произвольной строкой ключа
- В ansible.cfg добавил vault_password_file = vault.key
- Добавил vault.key в .gitignore

Создал playbooks/users.yml:
```
---
- name: Create users
  hosts: all
  become: true

  vars_files:
    - "{{ inventory_dir }}/credentials.yml"

  tasks:
    - name: create users
      user:
        name: "{{ item.key }}"
        password: "{{ item.value.password|password_hash('sha512', 65534|random(seed=inventory_hostname)|string) }}"
        groups: "{{ item.value.groups | default(omit) }}"
      with_dict: "{{ credentials.users }}"
```
Создал ansible/environments/prod/credentials.yml:
```
credentials:
  users:
    admin:
      password: admin123
      groups: sudo
```
Создал ansible/environments/stage/credentials.yml:
```
credentials:
  users:
    admin:
      password: qwerty123
      groups: sudo
    qauser:
      password: test123
```
Зашифровал файлы используя vault.key

![изображение](https://user-images.githubusercontent.com/85208391/126915066-c29385fe-47ae-41b5-a440-12595f1d4890.png)

![изображение](https://user-images.githubusercontent.com/85208391/126915067-36a739e8-64bb-4f75-ba33-3b08872137c0.png)

## Работа с Ansible Vault

![изображение](https://user-images.githubusercontent.com/85208391/126915239-090ffda4-5b35-4baf-bef4-f64867abc2ed.png)

![изображение](https://user-images.githubusercontent.com/85208391/126915242-8d470f38-10c5-4a47-a868-c532e94d4047.png)

Все отработало.















