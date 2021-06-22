# zagretdinov-d_infra
zagretdinov-d Infra repository

## Знакомство с облачной инфраструктурой Yandex.Cloud

## Задание

Запуск VM в Yandex Cloud, управление правилами фаервола, настройка SSH подключения, настройка SSH подключения через Bastion Host, настройка VPN сервера и VPN-подключения.
Цель:

В данном дз студент создаст виртуальные машины в GCP Compute Engine. Настроит bastion host и ssh. В данном задании тренируются навыки: создания виртуальных машин, настройки bastion host, ssh

Опишите в README.md и получившуюся конфигурацию и данные для
подключения в следующем формате (важно для проверки!):

## Полученные данные входе создания VM 
`
## bastion_IP = 84.201.158.166
## someinternalhost_IP = 10.128.0.14
`
## Процесс выполнения:
Создаю инстансы VM bastion и someinternal

Генерирую ключи

```
ssh-keygen -t rsa -f ~/.ssh/zagretdinov -C zagretdinov -P ""

```
## подключаюсь

![изображение](https://user-images.githubusercontent.com/85208391/122934820-acef1380-d391-11eb-9875-780f0252ef49.png)

## Подключаю Bastion host для внутренней сети
на локльной прописываю:
```
eval $(ssh-agent -s)
Agent pid 1739595
ssh-add ~/.ssh/zagretdinov
Identity added: /home/dpp/.ssh/zagretdinov (zagretdinov)
```
На Bastion проверяю отсутствие каких-либо приватных ключей

![изображение](https://user-images.githubusercontent.com/85208391/122936180-c5136280-d392-11eb-9edc-2797e4904a61.png)

## Самостоятельное задание

Исследовать способ подключения к someinternalhost
в одну команду из вашего рабочего устройства, проверить работоспособность
найденного решения и внести его в README.md в вашем репозитории

настраиваю подключения по алиасу

~/.ssh/config содержимое:

![изображение](https://user-images.githubusercontent.com/85208391/122936779-3e12ba00-d393-11eb-9e05-5985e3c26e86.png)

Проверяем работоспособность

![изображение](https://user-images.githubusercontent.com/85208391/122936885-55ea3e00-d393-11eb-8804-cb5702b8ab2f.png)


Дополнительное задание:


![изображение](https://user-images.githubusercontent.com/85208391/122937162-921d9e80-d393-11eb-9c80-98ec16548ef9.png)

и пропишу в хосты

```
sudo bash -c 'echo "10.128.0.14 someinternalhost" >> /etc/hosts'
```
Проверяю:

![изображение](https://user-images.githubusercontent.com/85208391/122937813-13753100-d394-11eb-87d6-3710bf1c2c7e.png)

## Создаю VPN-сервер для серверов Yandex.Cloud
```
$ cat <<EOF> setupvpn.sh
#!/bin/bash
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-4.4.list
echo "deb http://repo.pritunl.com/stable/apt focal main" > /etc/apt/sources.list.d/pritunl.list
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
apt-get --assume-yes update
apt-get --assume-yes upgrade
apt-get --assume-yes install pritunl mongodb-org
systemctl start pritunl mongod
systemctl enable pritunl mongod
EOF
```
## Выполняю скрипт sudo bash setupvpn.sh

выполняется установка mongodb и VPN-cервер pritunl

![изображение](https://user-images.githubusercontent.com/85208391/122940940-bc249000-d396-11eb-884d-1596db9945d9.png)

## Создаю VPN-сервер для серверов Yandex.Cloud

сгенерируйте установочный ключ и логин/пароль
```
sudo pritunl setup-key
от sudo pritunl default-password
```
Далее добавляем в веб интерфейсе на вкладке Users:
Организацию
Пользователя test с PIN 6214157507237678334670591556762
На вкладке Servers добавляем сервер, привязываем его к организации
и запускаем.

![изображение](https://user-images.githubusercontent.com/85208391/122941700-73210b80-d397-11eb-8c4e-e99abdfb1f89.png)

скачиваю конфигурационный файл добовляю и подключаю свою локальную машину к VPN
![изображение](https://user-images.githubusercontent.com/85208391/122942897-5e914300-d398-11eb-8323-57db6ea37ec1.png)

![изображение](https://user-images.githubusercontent.com/85208391/122943193-a021ee00-d398-11eb-82c0-3b16ee461947.png)

Проверяю возможность подключения к someinternalhost с вашего компьютера после подключения к VPN:
![изображение](https://user-images.githubusercontent.com/85208391/122943931-40781280-d399-11eb-90ac-f3f4c90acb2b.png)

## Дополнительное задание

![изображение](https://user-images.githubusercontent.com/85208391/122944283-7f0dcd00-d399-11eb-9af5-3084e3e63c84.png)

Добавил "Labels" cloud-bastion к  Pull Request.





