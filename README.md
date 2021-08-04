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













