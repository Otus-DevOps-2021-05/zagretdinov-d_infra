# zagretdinov-d_infra
zagretdinov-d Infra repository

## Домашнее задание

## Разработка и тестирование Ansible ролей и плейбуков

## Локальная разработка с Vagrant
Установил VirtualBox. Установил Vagrant.

![изображение](https://user-images.githubusercontent.com/85208391/127913609-540b463f-f681-4066-bc69-feba52d4231f.png)

Создал виртуалки, выполнил в директории ansible:

![изображение](https://user-images.githubusercontent.com/85208391/127913884-b209f7d1-d91e-48bc-9125-b98bb3649fb3.png)

![изображение](https://user-images.githubusercontent.com/85208391/127913908-ed6dc516-4a14-41b9-88aa-4202c8bd93bc.png)

Проверил статус машин:

![изображение](https://user-images.githubusercontent.com/85208391/127913961-fe8d5604-61c1-4b04-851e-17bcfedaf7c9.png)

Подключился по ssh на appserver и запустил ping.

![изображение](https://user-images.githubusercontent.com/85208391/127914210-58536721-b48a-4cbc-8484-f979787a871c.png)

## Доработка ролей
Добавил провижин ansible в Vagrantfile и доработал согласно задания устранив все ошибки:
Запуск ```vagrant provision dbserver```
![изображение](https://user-images.githubusercontent.com/85208391/127914772-7c99e5db-8f68-40c5-8597-749bee634fb6.png)

Проверяю работу роли:

![изображение](https://user-images.githubusercontent.com/85208391/127915764-76204696-6e2e-4bde-ba6d-bbb02af2d699.png)

![изображение](https://user-images.githubusercontent.com/85208391/127915847-571b88bd-4734-4f46-b61c-66e10dffdee2.png)

Тестирование роли

Добавил зависимости в requirements.txt:

...
molecule>=2.6
testinfra>=1.10
python-vagrant>=0.5.15

Установил зависимости используя virtualenv:

virtualenv venv
source venv/bin/activate

pip install -r ansible/requirements.txt

Создал заготовку для тестов роли db:

cd ansible/roles/db

molecule init scenario --scenario-name default -r db -d vagrant

Добавил несколько тестов в db/molecule/default/tests/test_default.py:

import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

# check if MongoDB is enabled and running
def test_mongo_running_and_enabled(host):
    mongo = host.service("mongod")
    assert mongo.is_running
    assert mongo.is_enabled

# check if configuration file contains the required line
def test_config_file(host):
    config_file = host.file('/etc/mongod.conf')
    assert config_file.contains('bindIp: 0.0.0.0')
    assert config_file.is_file

    Описание тестовой машины, которая создается Molecule для тестов содержится в файле db/molecule/default/molecule.yml.

molecule create

Создал VM для проверки роли:

molecule create

    molecule list - список инстансов

    molecule login -h instance - подключение к инстансу

Molecule init генерирует плейбук для применения нашей роли. Данный плейбук можно посмотреть по пути db/molecule/default/playbook.yml.

Добавил become: true и переменные в этот плейбук:

- name: Converge
  hosts: all
  become: true
  vars:
    mongo_bind_ip: 0.0.0.0
  roles:
    - role: db

Применил плейбук:

molecule converge

Прогнал тесты:

molecule verify

Самостоятельное задание

Добавил тест что монга слушает порт 27017

# check if MongoDB is listening on 0.0.0.0:27017
def test_mongo_socket(host):
    socket = host.socket("tcp://0.0.0.0:27017")
    assert socket.is_listening

В плейбуке packer_app.yml перешел на использование роли app:

- name: Install Ruby && Bundler
  hosts: all
  become: true
  roles:
    - app

В роль app добавил теги:

- include: ruby.yml
  tags:
    - ruby

- include: puma.yml
  tags:
    - puma

В packer/app.json добавил тег и путь до ролей:

"provisioners": [
  {
    "type": "ansible",
    "playbook_file": "ansible/playbooks/packer_app.yml",
    "ansible_env_vars": ["ANSIBLE_ROLES_PATH={{ pwd }}/ansible/roles"],
    "extra_arguments": ["--tags", "ruby"]
  }
]

В плейбуке packer_db.yml перешел на использование роли db:

- name: Install MongoDB
  hosts: all
  become: true
  roles:
    - db

В роль db добавил теги:

- include: install_mongo.yml
  tags:
    - install_mongo

- include: config_mongo.yml
  tags:
    - config_mongo

В packer/db.json добавил тег и путь до ролей:

"provisioners": [
  {
    "type": "ansible",
    "playbook_file": "ansible/playbooks/packer_db.yml",
    "ansible_env_vars": ["ANSIBLE_ROLES_PATH={{ pwd }}/ansible/roles"],
    "extra_arguments": ["--tags", "install_mongo"]
  }
]









Аналогично поправил роль app, добавив туда установку зависимостей.

Добавил провижин для appserver согласно задания и запустил:

```vagrant provision appserver```

![изображение](https://user-images.githubusercontent.com/85208391/127916424-14e60984-6a67-44b5-ae00-2dce713909bf.png)

## Проверка

Потушил вируталки:
```
vagrant destroy -f
```
Запустил:
```
vagrant up
```
Проверил что приложение доступно по адресу 10.10.10.20:9292.

![изображение](https://user-images.githubusercontent.com/85208391/128183341-2d4a56a6-7708-4d61-9f45-bf9b8e83cef4.png)

## Задание со *
В процессе был установлен nginx 

![изображение](https://user-images.githubusercontent.com/85208391/128184945-f93d2bd7-2270-4665-9fec-b37233f6451c.png)

## Задание

Дополните конфигурацию Vagrant для корректной работы проксирования приложения с помощью nginx.

Добавил в Vagrantfile в секцию extra_vars
```
ansible.extra_vars = {
       "deploy_user" => "ubuntu",
       nginx_sites: {
          default: ["listen 80", "server_name 'puma'", "location / {proxy_pass http://127.0.0.1:9292;}"]
     }
```
![изображение](https://user-images.githubusercontent.com/85208391/128185065-aac3c3c8-5854-4d82-a2db-a7240c34990d.png)


## Тестирование роли

Добавил зависимости в requirements.txt:
 ```
...
molecule>=2.6
testinfra>=1.10
python-vagrant>=0.5.15
```

Установил зависимости используя virtualenv:
```
virtualenv venv
source venv/bin/activate
pip install -r ansible/requirements.txt
```

Создал заготовку для тестов роли db:

```
cd ansible/roles/db
molecule init scenario --scenario-name default -r db -d vagrant
```
Добавил несколько тестов в db/molecule/default/tests/test_default.py:
```
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

# check if MongoDB is enabled and running
def test_mongo_running_and_enabled(host):
    mongo = host.service("mongod")
    assert mongo.is_running
    assert mongo.is_enabled

# check if configuration file contains the required line
def test_config_file(host):
    config_file = host.file('/etc/mongod.conf')
    assert config_file.contains('bindIp: 0.0.0.0')
    assert config_file.is_file
```

Описание тестовой машины, которая создается Molecule для тестов содержится в файле db/molecule/default/molecule.yml.
```
molecule create
```
Создал VM для проверки роли:

```
molecule create

    molecule list - список инстансов

    molecule login -h instance - подключение к инстансу
```
Molecule init генерирует плейбук для применения нашей роли. Данный плейбук можно посмотреть по пути db/molecule/default/playbook.yml.

Добавил become: true и переменные в этот плейбук:
```
- name: Converge
  hosts: all
  become: true
  vars:
    mongo_bind_ip: 0.0.0.0
  roles:
    - role: db
```
Применил плейбук:
```
molecule converge
```
Прогнал тесты:
```
molecule verify
```
Самостоятельное задание

Добавил тест что монга слушает порт 27017
```
# check if MongoDB is listening on 0.0.0.0:27017
def test_mongo_socket(host):
    socket = host.socket("tcp://0.0.0.0:27017")
    assert socket.is_listening
```
В плейбуке packer_app.yml перешел на использование роли app:
```
- name: Install Ruby && Bundler
  hosts: all
  become: true
  roles:
    - app
```
В роль app добавил теги:
```
- include: ruby.yml
  tags:
    - ruby

- include: puma.yml
  tags:
    - puma
```
В packer/app.json добавил тег и путь до ролей:
```
"provisioners": [
  {
    "type": "ansible",
    "playbook_file": "ansible/playbooks/packer_app.yml",
    "ansible_env_vars": ["ANSIBLE_ROLES_PATH={{ pwd }}/ansible/roles"],
    "extra_arguments": ["--tags", "ruby"]
  }
]
```
В плейбуке packer_db.yml перешел на использование роли db:
```
- name: Install MongoDB
  hosts: all
  become: true
  roles:
    - db
```
В роль db добавил теги:
```
- include: install_mongo.yml
  tags:
    - install_mongo

- include: config_mongo.yml
  tags:
    - config_mongo
```
В packer/db.json добавил тег и путь до ролей:

```
"provisioners": [
  {
    "type": "ansible",
    "playbook_file": "ansible/playbooks/packer_db.yml",
    "ansible_env_vars": ["ANSIBLE_ROLES_PATH={{ pwd }}/ansible/roles"],
    "extra_arguments": ["--tags", "install_mongo"]
  }
]
```










