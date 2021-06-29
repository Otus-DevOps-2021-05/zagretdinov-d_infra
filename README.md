# zagretdinov-d_infra
zagretdinov-d Infra repository

## Модели управления инфраструктурой. Подготовка образов с помощью Packer
Цель:

В данном дз студент произведет сборку готового образа с уже установленным приложением при помощи Packer. Задеплоит приложение в Compute Engine при помощи ранее подготовленного образа. В данном задании тренируются навыки: работы с Packer, работы с GCP Compute Engine.

## 1. Создание новой ветки
```
git checkout -b packer-base
```
c прошлого задания конфиги перенес в созданную директорию config-scripts


## 2. Установка Packer

Скачал и перенес файлик в папку bin.

![image](https://user-images.githubusercontent.com/85208391/123776592-3ef69f00-d8f1-11eb-8675-c2a0b0fb98f4.png)

![image](https://user-images.githubusercontent.com/85208391/123776923-8d0ba280-d8f1-11eb-925b-3c71efe9640b.png)


## 3. Создание сервисного аккаунта дляPacker в Yandex.CloudPacker в Yandex.Cloud
успешно после следцющих команд создал сервисный аккаунт и добавил роли и создал ключ.
```
$ SVC_ACCT="<придумайтеимя>"
$ FOLDER_ID="<заменитенасобственный>"
$ yc iam service-account create --name $SVC_ACCT --folder-id $FOLDER_ID
$ ACCT_ID=$(yc iam service-account get $SVC_ACCT | \
                                        grep ^id | \
                                        awk '{print $2}')
$ yc resource-manager folder add-access-binding --id $FOLDER_ID \    
                                        --role editor \    
                                        --service-account-id $ACCT_ID
yc iam key create --service-account-id $ACCT_ID --output <вставьтесвойпуть>/key.json
yc iam key create --service-account-id $ACCT_ID --output <вставьтесвойпуть>/key.json
```

![изображение](https://user-images.githubusercontent.com/85208391/123771152-a65e2000-d8ec-11eb-8ba9-534fe509da05.png)


 ## 4. Создание файла-шаблона Packer
 так же сразу провел добавление провиженеров и произвел исправления ошибок.
![image](https://user-images.githubusercontent.com/85208391/123777198-c3e1b880-d8f1-11eb-8c94-c150e3b977e0.png)

добавил в скрипт
```
"subnet_id": "{{user `subnet_id`}}",
"use_ipv4_nat": true,
```
Для скрипта install_ruby.sh при обновлении необходима пауза, так как процесс обновления еще не закончен, а уже выполняется установка. для этого я

```
echo "Sleep 30 sec for apt update"; sleep 30s; echo "start apt install"
```
Установка:

![image](https://user-images.githubusercontent.com/85208391/123779837-6602a000-d8f4-11eb-9b81-1bdde8bb3dfd.png)

![image](https://user-images.githubusercontent.com/85208391/123779864-6c911780-d8f4-11eb-8b85-a73bdf5d886d.png)

Закончил.

Проверяю образ сосздаю ВМ:

![image](https://user-images.githubusercontent.com/85208391/123780085-a2360080-d8f4-11eb-8fc7-ffc98e5c8699.png)

![image](https://user-images.githubusercontent.com/85208391/123780241-ce518180-d8f4-11eb-9a6b-c3599018a6c2.png)


Захожу и устанавливаю reddit:
```
ssh -i ~/.ssh/zagretdinov zagretdinov@178.154.207.107
sudo apt-get update
sudo apt-get install -y git
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
```
проверяю

![image](https://user-images.githubusercontent.com/85208391/123780816-68192e80-d8f5-11eb-9d09-0ee8821cc01d.png)


http://178.154.207.107:9292/

## Параметризирование шаблона
Cоздал variables.json, .gitignore файлы и для коммита в репозиторий variables.json.examples. В gitignore включил variables.json и key.json.

![image](https://user-images.githubusercontent.com/85208391/123781357-f55c8300-d8f5-11eb-96e7-d3a422a381eb.png)

![image](https://user-images.githubusercontent.com/85208391/123781583-3b194b80-d8f6-11eb-8ac1-a991a9e2da9c.png)

































