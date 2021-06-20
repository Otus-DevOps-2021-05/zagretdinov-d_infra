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
Damir@Damir:~$ eval "$(ssh-agent -s)"
Agent pid 24762
damir@Damir:~$ ssh-add -L
The agent has no identities.
damir@Damir:~$ ssh-add ~/.ssh/zagretdinov
Identity added: /home/damir/.ssh/zagretdinov (zagretdinov)

```
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
zagretdinov@bastion:~$ ls -la ~/.ssh/
total 16
drwx------ 2 zagretdinov zagretdinov 4096 Jun 20 18:44 .
drwxr-xr-x 4 zagretdinov zagretdinov 4096 Jun 20 18:41 ..
-rw------- 1 zagretdinov zagretdinov  565 Jun 20 18:34 authorized_keys
-rw-r--r-- 1 zagretdinov zagretdinov  444 Jun 20 18:53 known_hosts
zagretdinov@bastion:~$ 
Получается Хосты
someinternal - 178.154.254.210
someinternal - 10.128.0.14

## Самостоятельное задание. Исследовать способ подключения к someinternalhost в одну команду из вашего рабочего устройства:


Добавляю на свою локальную машину в ~/.ssh/config cкрипт с содержимым:
```
Host 178.154.254.210
  User zagretdinov
  IdentityFile /home/damir/.ssh/zagretdinov
Host 10.128.0.14
  User zagretdinov
  ProxyCommand ssh -W %h:%p 178.154.254.210
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
Host 178.154.254.210
  User zagretdinov
  IdentityFile /home/damir/.ssh/zagretdinov
#Host 10.128.0.14
Host someinternal
  User zagretdinov
  ProxyCommand ssh -W %h:%p 178.154.254.210
  IdentityFile /home/damir/.ssh/zagretdinov

```
и проверочка как нестранно оно работает

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
