# zagretdinov-d_infra
zagretdinov-d Infra repository

## Домашнее задание

## Создание Terraform модулей для управления компонентами инфраструктуры.

## Ресурс IP адреса
Так как создать новую сеть согласна заданию «"yandex_vpc_network" "app-network"» у меня не получится я буду пользватся тем что мне выдали по умолчанию по промокоду. 
И так первый шаг создания подсети я выполнил ледующим образом.
```
provider "yandex" {
service_account_key_file = var.service_account_key_file
cloud_id = var.cloud_id
folder_id = var.folder_id
zone = "ru-central1-a"
}

resource "yandex_vpc_subnet" "subnet" {
  name = "reddit-subnet"
  zone = "ru.central1-a"
  network_id = var.network.id
  v4_cidr_blocks = [var.cidr]
}
terraform apply
```
![изображение](https://user-images.githubusercontent.com/85208391/125015984-62101400-e092-11eb-9d73-aa4fa2b154db.png)


## Несколько VM

![изображение](https://user-images.githubusercontent.com/85208391/125016116-997ec080-e092-11eb-9e25-b0960560e4f4.png)

![изображение](https://user-images.githubusercontent.com/85208391/125016162-adc2bd80-e092-11eb-8160-6b6a22270414.png)

## Создадим две VM
Запечетлил процесс работы скриншотами.
![изображение](https://user-images.githubusercontent.com/85208391/125016868-df885400-e093-11eb-91a2-9fb521417ec7.png)

![изображение](https://user-images.githubusercontent.com/85208391/125016884-e8792580-e093-11eb-9c61-9b27c082e0af.png)

![изображение](https://user-images.githubusercontent.com/85208391/125016908-f5961480-e093-11eb-99f9-9b80739dc642.png)

![изображение](https://user-images.githubusercontent.com/85208391/125016927-fc248c00-e093-11eb-9dc8-e6bc273067cc.png)

![изображение](https://user-images.githubusercontent.com/85208391/125016946-02b30380-e094-11eb-86a9-013b4a7ef464.png)

![изображение](https://user-images.githubusercontent.com/85208391/125016973-10688900-e094-11eb-83ff-4f4f194d929e.png)


В результате:

![изображение](https://user-images.githubusercontent.com/85208391/125016450-35103100-e093-11eb-9a45-3894066599fa.png)

![изображение](https://user-images.githubusercontent.com/85208391/125016557-5d982b00-e093-11eb-8822-01e81eae3860.png)

## Создания модулей
Так же демонстрация скриншотами.

![изображение](https://user-images.githubusercontent.com/85208391/125019626-2fb5e500-e099-11eb-8030-3267aa7f9b01.png)

![изображение](https://user-images.githubusercontent.com/85208391/125019761-5ffd8380-e099-11eb-8f9d-6bae1767cc60.png)

![изображение](https://user-images.githubusercontent.com/85208391/125022205-f469e500-e09d-11eb-9fcf-30909f76310d.png)

![изображение](https://user-images.githubusercontent.com/85208391/125022228-021f6a80-e09e-11eb-89bf-e0289b322efa.png)

![изображение](https://user-images.githubusercontent.com/85208391/125022242-08ade200-e09e-11eb-9406-d2ef388b058d.png)

![изображение](https://user-images.githubusercontent.com/85208391/125022265-16fbfe00-e09e-11eb-92f3-4144cf1f5213.png)

![изображение](https://user-images.githubusercontent.com/85208391/125022297-2ed38200-e09e-11eb-9f95-1ceec9f342d1.png)

![изображение](https://user-images.githubusercontent.com/85208391/125022560-c8029880-e09e-11eb-96ff-454e289b731f.png)

![изображение](https://user-images.githubusercontent.com/85208391/125022573-d18c0080-e09e-11eb-8ee4-99fa722f3cd0.png)

![изображение](https://user-images.githubusercontent.com/85208391/125022862-70186180-e09f-11eb-8c03-3c7915579fac.png)

успешно установилось и работает.

![изображение](https://user-images.githubusercontent.com/85208391/125022901-858d8b80-e09f-11eb-8884-49c390921add.png)

![изображение](https://user-images.githubusercontent.com/85208391/125022925-8faf8a00-e09f-11eb-86c7-f64e944e8564.png)

## Создание Stage & Prod

![изображение](https://user-images.githubusercontent.com/85208391/125023039-dc936080-e09f-11eb-9f14-7672451f7b4d.png)

Идентично скопировал. Все работает.

![изображение](https://user-images.githubusercontent.com/85208391/125023138-0ba9d200-e0a0-11eb-9b07-40858a892ace.png)

Удалил из папки terraform файлы main.tf, outputs.tf, terraform.tfvars, variables.tf, так как они теперь перенесены в stage и prod

## Задание со звездой.
В ообщем создал файл backend.tf в двух директориях.

![изображение](https://user-images.githubusercontent.com/85208391/125023230-398f1680-e0a0-11eb-8d2a-5b10d9987ec9.png)

С конфигурационных содержанием
```
terraform {
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "zagretdinov-d-infra-terraform"
    region   = "ru-central1"
    key      = "prod/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

```
![изображение](https://user-images.githubusercontent.com/85208391/125023334-7ce98500-e0a0-11eb-9212-d636cac7da96.png)

![изображение](https://user-images.githubusercontent.com/85208391/125023340-84a92980-e0a0-11eb-9d45-cae64998ce90.png)

Настроил хранение state в yandex object storage.
Скопировал с сервисного аккаунт access key.
```
yc iam access-key create --service-account-name SERVICE_ACCOUNT_NAME
```
Для инициализации backend указал реквизиты при запуске terraform init
```
terraform init -backend-config="access_key=YOUR_ACCESS_KEY" -backend-config="secret_key=YOUR_SECRET_KEY"
```
в результате на примере получилось

![изображение](https://user-images.githubusercontent.com/85208391/125023606-0b5e0680-e0a1-11eb-8738-76a59c71f47f.png)

и вот оно появилось.

![изображение](https://user-images.githubusercontent.com/85208391/125023657-20d33080-e0a1-11eb-91d4-1745ebe0c049.png)

## Заданиес**

Добавил необходимые provisioner в модули для деплоя и работы приложения. Файлы, используемые в provisioner, находятся в директории модуля

![изображение](https://user-images.githubusercontent.com/85208391/125023984-bff82800-e0a1-11eb-8e11-b2c129edace3.png)

Один из скриншотом наблюдения как устанавливались приложении и БД.

![изображение](https://user-images.githubusercontent.com/85208391/125024322-56c4e480-e0a2-11eb-9345-282524415d5b.png)





































