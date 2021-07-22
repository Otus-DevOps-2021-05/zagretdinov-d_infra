# zagretdinov-d_infra
zagretdinov-d Infra repository

## Домашнее задание

## Деплой и управление конфигурацией сконфигурацией с Ansible

Создаю новую ветку, называю ansible-2.

Комментирую код провижининга для app и db модулей.

![изображение](https://user-images.githubusercontent.com/85208391/126520118-a2f606b2-88b7-4cb2-ba73-030eb0f915f1.png)


## Один playbook, один сценарий

Создал плейбук reddit_app.yml:

![изображение](https://user-images.githubusercontent.com/85208391/126521499-b514e4b3-2483-444e-aabc-ce8c5655ecbb.png)


Добавил шаблон для mongodb templates/mongod.conf.j2

![изображение](https://user-images.githubusercontent.com/85208391/126522916-945045e6-afa3-4a5a-b8a1-1add723fffc6.png)

Задал переменную:
```
vars: 
   mongo_bind_ip: 0.0.0.0
```
## Пробный прогон
--check пробный прогон
--limit выполняет плейбук только для переданных хостов
--tags выполняет таски с переданными тегами
  ```
ansible-playbook reddit_app.yml --check --limit db --tags db-tag
ansible-playbook reddit_app.yml --limit db --tags db-tag
```
![изображение](https://user-images.githubusercontent.com/85208391/126525473-afd15b7b-d0ee-4add-a610-c8190e14464b.png)

Добавил файл files/puma.service:

![изображение](https://user-images.githubusercontent.com/85208391/126528666-aa2b6a92-6600-45cf-8cd3-43f7946b67f4.png)

Добавил шаблон templates/mongod.conf.j2, в который будет подставляться адрес db_host:

![изображение](https://user-images.githubusercontent.com/85208391/126529949-ff30a6d9-7969-46fa-96d3-1f99605db13d.png)

Добавил таски и хендлер для app:

![изображение](https://user-images.githubusercontent.com/85208391/126530630-06a1ca1c-f35b-49ac-87b6-b3262225edd1.png)

Запустил пробный прогон и применил плейбук:

```
ansible-playbook reddit_app.yml --check --limit app --tags app-tag
ansible-playbook reddit_app.yml --limit app --tags app-tag
```

![изображение](https://user-images.githubusercontent.com/85208391/126531682-7f53109e-db78-43d4-8aba-3be34ac74167.png)


## Настройка инстанса приложения
Добавил  в сценарии  таск  для  копирования  unit-файла
```
  tasks:
    - name: Add unit file for Puma
      copy:
        src: files/puma.service
        dest: /etc/systemd/system/puma.service
      notify: reload puma
      
   - name: enable puma
      become: true
      systemd: name=puma enabled=yes
      tags: app-tag
```  
добавил новый handler

```
handlers: #Добавим блок handlers и задачу
    - name: restart mongod
      become: true
      service: name=mongod state=restarted

    - name: reload puma
      become: true
      systemd: name=puma state=restarted
```
![изображение](https://user-images.githubusercontent.com/85208391/126535924-136295ef-044d-4457-a4d7-a58c63057200.png)


![изображение](https://user-images.githubusercontent.com/85208391/126536113-741c2922-3249-4ea7-8815-2527db67a4c6.png)


![изображение](https://user-images.githubusercontent.com/85208391/126536147-86626039-78e6-4a3f-be40-6fc94ea49a10.png)


## Деплой
Добавил еще несколько тасков в сценарий плейбука.
```
  - name: Fetch the latest version of application code
      git:
        repo: 'https://github.com/express42/reddit.git'
        dest: /home/ubuntu/reddit
        version: monolith #Указываемнужнуюветку
      tags: deploy-tag
      notify: reload puma

    - name: Bundle install
      bundler:
        state: present
        chdir: /home/ubuntu/reddit
      tags: deploy-tag
```
Выполняю деплой
![изображение](https://user-images.githubusercontent.com/85208391/126538193-1be8c3a1-b5ea-4ebb-a4c2-d7ced26b0aa0.png)

![изображение](https://user-images.githubusercontent.com/85208391/126538255-878cde30-d257-4aa9-9161-f7161802fc09.png)

## Один плейбук,несколько сценариев.
Скопировал все что касается db в отдельный файл - reddit_app2.yml, при это поправил описание, унес become и tags на уровень выше, поменял hosts.
Для DB
```
---
- name: Configure MongoDB
  hosts: db
  tags: db-tag
  become: true
  vars:
    mongo_bind_ip: 0.0.0.0
  tasks:
    - name: Change mongo config file
      template:
        src: templates/mongod.conf.j2
        dest: /etc/mongod.conf
        mode: 0644
      notify: restart mongod
  handlers:
  - name: restart mongod
    service: name=mongod state=restarted
```
Для App
```
- name: Configure App
  hosts: app
  tags: app-tag
  become: true
  vars:
   db_host: 192.168.10.4
  tasks:
    - name: Add unit file for Puma
      copy:
        src: files/puma.service
        dest: /etc/systemd/system/puma.service
      notify: reload puma
    - name: Add config for DB connection
      template:
        src: templates/db_config.j2
        dest: /home/ubuntu/db_config
        owner: ubuntu
        group: ubuntu
    - name: enable puma
      systemd: name=puma enabled=yes
  handlers:
  - name: reload puma
    systemd: name=puma state=restarted
```
Для Deploy
```
- name: Deploy App
  hosts: app
  tags: deploy-tag
  become: true
  tasks:
    - name: Fetch the latest version of application code
      git:
        repo: 'https://github.com/express42/reddit.git'
        dest: /home/ubuntu/reddit
        version: monolith
      notify: restart puma

    - name: bundle install
      bundler:
        state: present
        chdir: /home/ubuntu/reddit

  handlers:
  - name: restart puma
    become: true
    systemd: name=puma state=restarted
```
Для чистоты проверки наших плейбуков пересоздадим инфраструктуруокружения stage, используя команды:
```
$ terraform destroy
$ terraform apply -auto-approve=false
```


Применил изменения:
```
ansible-playbook reddit_app2.yml --check --tags db-tag
ansible-playbook reddit_app2.yml --tags db-tag

ansible-playbook reddit_app2.yml --check --tags app-tag
ansible-playbook reddit_app2.yml --tags app-tag

ansible-playbook reddit_app2.yml --check --tags deploy-tag
ansible-playbook reddit_app2.yml --tags deploy-tag
```


![изображение](https://user-images.githubusercontent.com/85208391/126541047-f2250b7e-fedb-43b6-83f8-9f30aed411f4.png)

![изображение](https://user-images.githubusercontent.com/85208391/126541090-f479cdcd-0638-4304-9f7e-e707ec33b12b.png)

![изображение](https://user-images.githubusercontent.com/85208391/126541142-580ddab4-f2a8-44d3-92a4-e076894ce5d5.png)

![изображение](https://user-images.githubusercontent.com/85208391/126543661-d916953b-6150-4606-ada0-657c03964784.png)

## Несколько плейбуков

Создал три файла:

    app.yml
    db.yml
    deploy.yml

Перенес туда код из reddit_app2.yml, удалив теги

Переименовал предыдущие плейбуки:

    reddit_app.yml -> reddit_app_one_play.yml
    reddit_app2.yml -> reddit_app_multiple_plays.yml

Создал файл site.yml:

![изображение](https://user-images.githubusercontent.com/85208391/126544850-2a2e0fcf-6b30-496f-9259-fdca06df875d.png)

Применил плейбук

ansible-playbook site.yml --check
ansible-playbook site.yml

![изображение](https://user-images.githubusercontent.com/85208391/126545016-06f765e8-73b0-485c-b326-c909da232c44.png)

![изображение](https://user-images.githubusercontent.com/85208391/126545049-67d5d4d6-cdc5-49ca-a2e0-65ed30ae26c8.png)

![изображение](https://user-images.githubusercontent.com/85208391/126545093-841e5f17-799e-4599-a9a9-441dcb1497fd.png)

## Задание со ⭐

Динамический инвентарь отражен в ansible.cfg и плейбуках

## Провижининг в Packer

Создаю плейбуки ansible/packer_app.yml и ansible/packer_db.yml.
И так packer_app.yml - устанавливает Ruby и Bundler и скрипт выглядит следующим образом

![изображение](https://user-images.githubusercontent.com/85208391/126546077-ec917d8a-9b8a-4853-8cc6-336166a98b64.png)

Интегрируем Ansible в Packer

![изображение](https://user-images.githubusercontent.com/85208391/126546189-d25586fb-0b2e-45aa-a887-7f84992aa252.png)

Выполняю билд app.json.

![изображение](https://user-images.githubusercontent.com/85208391/126546326-52ecef26-038f-4fe7-acad-1b6e3b53a8f2.png)

Как видно успешно создался  образ reddit-app1  как я и хотел.

Создаю теперь ansible/packer_db.yml.

Packer_db.yml - добавляет репозиторий MongoDB, устанавливает ее и включает сервис.

![изображение](https://user-images.githubusercontent.com/85208391/126546509-59e8b42e-46fe-4f66-bfc1-8adda6d922ce.png)

Интегрирую Ansible в Packer

![изображение](https://user-images.githubusercontent.com/85208391/126546702-337da750-e489-4dc5-9281-593f0f59758f.png)

Итого:

![изображение](https://user-images.githubusercontent.com/85208391/126546757-537d66c6-901f-4ee3-8bbb-a6ec9e143c12.png)

![изображение](https://user-images.githubusercontent.com/85208391/126546806-45352866-8db0-4b55-9e07-71578adbacf9.png)

итого создан успешно образ reddit-db1.

На основе созданных app и db образов настраиваю и запускаю stage окружение.

![изображение](https://user-images.githubusercontent.com/85208391/126546993-c62f31cc-e456-42bb-8ed6-333c94c23e64.png)

Проверяю, что c помощью плейбука site.yml из предыдущего раздела окружение конфигурируется, а приложение деплоится и работает.

![изображение](https://user-images.githubusercontent.com/85208391/126547256-8fba5b80-6a16-4f1b-901c-5c6de171097b.png)


Проверка! Все работает

![изображение](https://user-images.githubusercontent.com/85208391/126547352-91be05b7-ee52-4fea-abf4-e9f787cf2da9.png)

























