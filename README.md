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




























