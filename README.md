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








