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
























