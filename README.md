# zagretdinov-d_infra
zagretdinov-d Infra repository
#**Тема: Знакомство с облачной инфраструктурой Yandex.Cloud**

## **Задание:**
Запуск VM в Yandex Cloud, управление правилами фаервола, настройка SSH подключения, настройка SSH подключения через Bastion Host, настройка VPN сервера и VPN-подключения.

Цель:
В данном дз студент создаст виртуальные машины в Yandex.Cloud. Настроит bastion host и ssh. В данном задании тренируются навыки: создания виртуальных машин, настройки bastion host, ssh

Все действия описаны в методическом указании.

Критерии оценки:
0 б. - задание не выполнено 1 б. - задание выполнено 2 б. - выполнены все дополнительные задания

---

## **Выполнено:**
Генерю пару ключи ssh-keygen -t rsa -f ~/.ssh/zagretdinov -C zagretdinov -P ""
Подключаюсь
```
damir@Damir:~$ ssh -i ~/.ssh/zagretdinov -A zagretdinov@178.154.254.210
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Last login: Sun Jun 20 18:43:33 2021 from 188.0.139.194

```
Далее подключаю второй host к истансам внутренней сети
```
Damir@Damir:~$ eval "$(ssh-agent -s)"
Agent pid 24762
damir@Damir:~$ ssh-add -L
The agent has no identities.
damir@Damir:~$ ssh-add ~/.ssh/zagretdinov
Identity added: /home/damir/.ssh/zagretdinov (zagretdinov)
zagretdinov@bastion:~$ ssh 10.128.0.14
The authenticity of host '10.128.0.14 (10.128.0.14)' can't be established.
ECDSA key fingerprint is SHA256:2E8YmHoGKeoSEHqvvTYdka9D+LLhML0mMXy86EtEcVk.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.128.0.14' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

zagretdinov@someinternal:~$ 

```
В бастионе нет ничего лишнего.
```
zagretdinov@bastion:~$ ls -la ~/.ssh/
total 16
drwx------ 2 zagretdinov zagretdinov 4096 Jun 20 18:44 .
drwxr-xr-x 4 zagretdinov zagretdinov 4096 Jun 20 18:41 ..
-rw------- 1 zagretdinov zagretdinov  565 Jun 20 18:34 authorized_keys
-rw-r--r-- 1 zagretdinov zagretdinov  444 Jun 20 18:53 known_hosts
zagretdinov@bastion:~$ 
Получается Хосты
bastion_IP - 84.201.158.166
someinternal_IP - 10.128.0.14
```

## Самостоятельное задание. Исследовать способ подключения к someinternalhost в одну команду из вашего рабочего устройства:


Добавляю на свою локальную машину в ~/.ssh/config cкрипт с содержимым:
```
Host 84.201.158.166
  User zagretdinov
  IdentityFile /home/damir/.ssh/zagretdinov
Host 10.128.0.14
  User zagretdinov
  ProxyCommand ssh -W %h:%p 84.201.158.166
  IdentityFile /home/damir/.ssh/zagretdinov

```

И оно работает:
```
damir@Damir:~$ ssh 10.128.0.14
The authenticity of host '10.128.0.14 (<no hostip for proxy command>)' can't be established.
ECDSA key fingerprint is SHA256:2E8YmHoGKeoSEHqvvTYdka9D+LLhML0mMXy86EtEcVk.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.128.0.14' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Sun Jun 20 18:53:13 2021 from 10.128.0.5
zagretdinov@someinternal:~$

```
## Дополнительное задание:

На локальной машине в /etc/hosts добавляю запись
```
10.128.0.14 someinternal

```

и в ~/.ssh/config меняю:
```
Host 84.201.158.166
  User zagretdinov
  IdentityFile /home/damir/.ssh/zagretdinov
#Host 10.128.0.14
Host someinternal
  User zagretdinov
  ProxyCommand ssh -W %h:%p 84.201.158.166
  IdentityFile /home/damir/.ssh/zagretdinov

```
и проверочка как ни странно оно работает

```
amir@Damir:~$ ssh someinternal
The authenticity of host 'someinternal (<no hostip for proxy command>)' can't be established.
ECDSA key fingerprint is SHA256:2E8YmHoGKeoSEHqvvTYdka9D+LLhML0mMXy86EtEcVk.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'someinternal' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Sun Jun 20 19:36:17 2021 from 10.128.0.5
zagretdinov@someinternal:~$

```
## VPN-сервер для серверов Yandex.Cloud
С готового скрипта установил mongodb и VPN-cервер pritunl проверяю статус. 
``` 
sudo bash setupvpn.sh
zagretdinov@bastion:~$ systemctl status mongod.service
● mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2021-06-20 20:48:35 UTC; 4min 42s ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 25676 (mongod)
     Memory: 89.9M
     CGroup: /system.slice/mongod.service
             └─25676 /usr/bin/mongod --config /etc/mongod.conf

```
сгенерирую установочный ключ zagretdinov@bastion:~$ 
```
sudo pritunl setup-key
```
и получаю логин и пароль
```
sudo pritunl default-password
```
После настройки создаем пользователя test с PIN 6214157507237678334670591556762, 
добавляю сервер и организацию и включаю в организацию пользователя и сервер.
Файл настройки клиента VPN (пользователь = test) - cloud-bostion.ovpn
небольшой процесс подключения с моего ПК 

![изображение](https://user-images.githubusercontent.com/85208391/122690968-6c3ab180-d24e-11eb-891b-55fe3724da99.png)


![изображение](https://user-images.githubusercontent.com/85208391/122691014-cfc4df00-d24e-11eb-9324-0c73f3a8d596.png)


Проверяю возможность подключения к someinternalhost
```
damir@Damir:~$ ssh -i ~/.ssh/zagretdinov zagretdinov@10.128.0.14
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Sun Jun 20 23:12:20 2021 from 10.128.0.5
```
Работает!
Ну и в принципе можно проверить на самом сервере что тунель поднят.

![изображение](https://user-images.githubusercontent.com/85208391/122691342-e4a27200-d250-11eb-8b62-8a89153706c2.png)

## Дополнительное задание
84.201.158.166.sslip.io прописываю в настройка Pritunl в домене.

Доступ к Pritunl - https://84.201.158.166.sslip.io

![изображение](https://user-images.githubusercontent.com/85208391/122691465-a5c0ec00-d251-11eb-87a7-fb9781b3c214.png)


![изображение](https://user-images.githubusercontent.com/85208391/122694207-782e6f80-d25e-11eb-9e37-4fef8593c104.png)






