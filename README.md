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

