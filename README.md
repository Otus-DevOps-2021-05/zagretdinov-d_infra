# zagretdinov-d_infra
zagretdinov-d Infra repository

## Домашнее задание

## Декларативное описание в виде кода инфраструктуры YC, требуемой для запуска тестового приложения, при помощи Terraform.


## Установка Terraform
Скаченная версия перемещена в папку bin.

![изображение](https://user-images.githubusercontent.com/85208391/124372688-03bbed80-dcae-11eb-9fe1-06f1e705c1ee.png)

![изображение](https://user-images.githubusercontent.com/85208391/124372699-16cebd80-dcae-11eb-8edc-2e645151a89f.png)

Создаю новую ветку ``` git checkout -b terraform - 1 ```

В корне репозитория создаю файл с содержимым

![изображение](https://user-images.githubusercontent.com/85208391/124372768-b12f0100-dcae-11eb-8006-9c79e71351af.png)

создаю главный конфигурационныйфайл файл: main.tf
определяю  секцию  Provider, ресурсы и интерфейс.

![изображение](https://user-images.githubusercontent.com/85208391/124373323-3caa9100-dcb3-11eb-8954-cf0879ad35ce.png)


создаю отдельный service account

```
yc config list
$ SVC_ACCT=""
$ FOLDER_ID=""
$ yc iam service-account create --name $SVC_ACCT --folder-id $FOLDER_ID
$ ACCT_ID=$(yc iam service-account get $SVC_ACCT | \ 
grep ^id | \ 
awk '{print $2}')
$ yc resource-manager folder add-access-binding --id $FOLDER_ID \ 
--role editor \ 
--service-account-id $ACCT_ID
yc iam key create --service-account-id $ACCT_ID --output <вставьтесвойпуть>/key.jcon
```

![изображение](https://user-images.githubusercontent.com/85208391/124372853-6feb2100-dcaf-11eb-8c77-5b34bdadca81.png)

## Terraform initTerrafo

![изображение](https://user-images.githubusercontent.com/85208391/124372893-af197200-dcaf-11eb-87f0-bb5dcd5494e0.png)

## Ресурсная модель
В файле main.tf после определения провайдера, добавляю ресурс для создания инстанса VM в YC и проверяю
```
terraform init
terraform plan
terraform apply
```

![изображение](https://user-images.githubusercontent.com/85208391/124372926-0cadbe80-dcb0-11eb-9622-47e8a49f3f95.png)


VM создана успешна.

![изображение](https://user-images.githubusercontent.com/85208391/124372936-1afbda80-dcb0-11eb-9f14-8934df1db85e.png)


![изображение](https://user-images.githubusercontent.com/85208391/124372938-1fc08e80-dcb0-11eb-8aae-d8cd481b2bbb.png)

## terraform show
```
terraform show | grep nat_ip_address
nat_ip_address     = "178.154.229.124"
```

Добавим SSH ключ для пользователя ubuntu

подключаемся
ssh ubuntu@178.154.229.124


![изображение](https://user-images.githubusercontent.com/85208391/124372958-441c6b00-dcb0-11eb-864b-6d79ab303882.png)

подключение успешно.

## Output vars

создаю отдельный файлик с конфигурациями, с названием outputs.tf

![изображение](https://user-images.githubusercontent.com/85208391/124372983-7928bd80-dcb0-11eb-8a2a-a5e6b6934f61.png)


Используя следующие команды можно просмотреть выходнык переменные

![изображение](https://user-images.githubusercontent.com/85208391/124373045-ffdd9a80-dcb0-11eb-9fef-724216297bef.png)


## Добавляю provisioners

![изображение](https://user-images.githubusercontent.com/85208391/124373058-197ee200-dcb1-11eb-8a86-677f20d71c58.png)

создаю файлы с содержимым в папке files

![изображение](https://user-images.githubusercontent.com/85208391/124373064-27ccfe00-dcb1-11eb-879b-9050ffa8360b.png)

![изображение](https://user-images.githubusercontent.com/85208391/124373066-2bf91b80-dcb1-11eb-9f54-d73c629f767a.png)


## Параметр подключение provisioners

![изображение](https://user-images.githubusercontent.com/85208391/124373083-46cb9000-dcb1-11eb-9103-d8a2f2102382.png)

## Проверяем работу провижинеровПроверяем работу провижи

```
terraform taint yandex_compute_instance.app[0]
Resource instance yandex_compute_instance.app[0] has been marked as tainted.
terraform plan
terraform apply
```

Проверяю работу приложения

external_ip_address_app = 84.201.129.118


![изображение](https://user-images.githubusercontent.com/85208391/124373105-6c589980-dcb1-11eb-90e0-1cfa284634ba.png)


## Input vars
Для использования входных переменных создаю следующие конфигурационные файлы.

![изображение](https://user-images.githubusercontent.com/85208391/124373155-a0cc5580-dcb1-11eb-9cf5-6478907a19ac.png)

![изображение](https://user-images.githubusercontent.com/85208391/124373158-a75acd00-dcb1-11eb-97af-245c82373730.png)

![изображение](https://user-images.githubusercontent.com/85208391/124373160-aaee5400-dcb1-11eb-9b3a-94164e2961c6.png)

## Финальная проверка

Пересоздаю все ресурсы 
```
terraform destroy
terraform plan
terraform apply
```
![изображение](https://user-images.githubusercontent.com/85208391/124373213-25b76f00-dcb2-11eb-9926-0d5de6caf110.png)

external_ip_address_app = 178.154.228.93

http://178.154.228.93:9292/

![изображение](https://user-images.githubusercontent.com/85208391/124373237-5f887580-dcb2-11eb-8142-5eb12ad9f097.png)


## Самостоятельные задания

![изображение](https://user-images.githubusercontent.com/85208391/124374974-358a7f80-dcc1-11eb-92ef-9a1cbe25bd6c.png)





































