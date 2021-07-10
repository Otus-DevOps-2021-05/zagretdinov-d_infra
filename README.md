# zagretdinov-d_infra
zagretdinov-d Infra repository

## Домашнее задание

## Управление конфигурацией.Основные DevOps инструменты. Знакомство с Ansible

План
Установка Ansible
Знакомство с базовыми функциями и инвентори
Выполнение различных модулей на подготовленной в прошлых ДЗ
инфраструктуре
Пишем простой плейбук

## Начало
Создал новую ветку ansible-1.

## Ansible, установка и настройка клиента

![изображение](https://user-images.githubusercontent.com/85208391/125161653-624d0400-e1a5-11eb-9caf-f42d824297da.png)

![изображение](https://user-images.githubusercontent.com/85208391/125161661-6842e500-e1a5-11eb-96a2-71e54b887720.png)

![изображение](https://user-images.githubusercontent.com/85208391/125161663-6b3dd580-e1a5-11eb-9576-5d17de8b2f51.png)


## Запуск Vms

![изображение](https://user-images.githubusercontent.com/85208391/125161673-78f35b00-e1a5-11eb-9dc1-2fb1b52a204c.png)

## Inventory file

![изображение](https://user-images.githubusercontent.com/85208391/125161682-84468680-e1a5-11eb-969e-0f33957f63a6.png)

![изображение](https://user-images.githubusercontent.com/85208391/125161687-8ad4fe00-e1a5-11eb-8e74-bfb9470cb5b0.png)

## Повторим для инстанса БД

![изображение](https://user-images.githubusercontent.com/85208391/125161700-9cb6a100-e1a5-11eb-9995-4331efd35b2a.png)

![изображение](https://user-images.githubusercontent.com/85208391/125161704-a2ac8200-e1a5-11eb-985e-085f3be4e965.png)

## Параметры ansible.cfg

![изображение](https://user-images.githubusercontent.com/85208391/125161710-a9d39000-e1a5-11eb-80ee-626add85f7d4.png)

Изменим инвентори

![изображение](https://user-images.githubusercontent.com/85208391/125161725-b7891580-e1a5-11eb-8c71-ff2033020ddb.png)

Проверим работу

![изображение](https://user-images.githubusercontent.com/85208391/125161737-c53e9b00-e1a5-11eb-8bde-5bbef49d24c7.png)


## Работа с группами хостов

![изображение](https://user-images.githubusercontent.com/85208391/125161748-d5567a80-e1a5-11eb-9851-7a98443ba6fd.png)

![изображение](https://user-images.githubusercontent.com/85208391/125161751-d9829800-e1a5-11eb-880d-78d74f978ce1.png)

## Использование YAML inventory

![изображение](https://user-images.githubusercontent.com/85208391/125161753-e7381d80-e1a5-11eb-8968-fc22a0fb6666.png)

![изображение](https://user-images.githubusercontent.com/85208391/125161755-ebfcd180-e1a5-11eb-9133-f44b1cda89df.png)

## Выполнение команд

Проверим, что на app сервере установлены компоненты для работы
приложения ( ruby и bundler ):

![изображение](https://user-images.githubusercontent.com/85208391/125161770-ffa83800-e1a5-11eb-9e98-efdbbe11093a.png)

В то же время модуль shell успешно отработает:

![изображение](https://user-images.githubusercontent.com/85208391/125161773-08007300-e1a6-11eb-9467-8d5860692aa8.png)

Модуль command выполняет команды, не используя оболочку ( sh, bash ), поэтому в нем не работают перенаправления потоков и нет доступа к некоторым переменным окружения.


Проверим на хосте с БД статус сервиса MongoDB с помощью модуля command или shell . (Эта операция аналогична запуску на хосте команды systemctl status mongod ):

![изображение](https://user-images.githubusercontent.com/85208391/125161810-4ac24b00-e1a6-11eb-9dd7-8f31fd895b01.png)


А можем выполнить ту же операцию используя модуль systemd, который предназначен для управления сервисами:

![изображение](https://user-images.githubusercontent.com/85208391/125161834-64fc2900-e1a6-11eb-8f5e-8678138ec753.png)

Или еще лучше с помощью модуля service , который более универсален и будет работать и в более старых ОС с init.d-инициализацией:

![изображение](https://user-images.githubusercontent.com/85208391/125161845-72191800-e1a6-11eb-9c98-05e18dd13a0d.png)


Используем модуль git для клонирования репозитория с приложением на app сервер:

![изображение](https://user-images.githubusercontent.com/85208391/125161849-7e9d7080-e1a6-11eb-9624-3945ae385492.png)


И попробуем сделать то же самое с модулем command:

![изображение](https://user-images.githubusercontent.com/85208391/125161859-8f4de680-e1a6-11eb-86b1-75da89c3d802.png)

в результате ошибка.

## Напишем простой плейбу
Реализуем простой плейбук, который выполняет аналогичные предыдущему слайду действия (клонирование репозитория).

![изображение](https://user-images.githubusercontent.com/85208391/125161877-b5738680-e1a6-11eb-8b67-23dfe094a13f.png)

![изображение](https://user-images.githubusercontent.com/85208391/125161886-c3290c00-e1a6-11eb-80f8-ce2ba5123daa.png)

Выполню ansible ```app -m command -a 'rm -rf ~/reddit'```
в рзультате:

![изображение](https://user-images.githubusercontent.com/85208391/125162006-6d089880-e1a7-11eb-9067-4a885aa12212.png)

![изображение](https://user-images.githubusercontent.com/85208391/125162205-6e869080-e1a8-11eb-8521-4ff6c0e4390f.png)

Ответ: произошли изменения в репозитории так как командой rm -rf ~/reddit удалили.

## Задание со ⭐

Создаем файл inventory.json c содержимым

![изображение](https://user-images.githubusercontent.com/85208391/125162376-477c8e80-e1a9-11eb-88d0-8b75d4060c4c.png)


Проверяю:

![изображение](https://user-images.githubusercontent.com/85208391/125162425-87dc0c80-e1a9-11eb-8410-058bdfab748d.png)




















