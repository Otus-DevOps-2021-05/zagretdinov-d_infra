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

![изображение](https://user-images.githubusercontent.com/85208391/125016310-f37f8600-e092-11eb-8e1e-0ddd9ccaf31e.png)

![изображение](https://user-images.githubusercontent.com/85208391/125016277-e6fb2d80-e092-11eb-8c3a-5489a323fbb5.png)

![изображение](https://user-images.githubusercontent.com/85208391/125016249-d77be480-e092-11eb-8b6b-ad24f13994ff.png)

![изображение](https://user-images.githubusercontent.com/85208391/125016327-fda18480-e092-11eb-8152-9de28739c289.png)

![изображение](https://user-images.githubusercontent.com/85208391/125016347-07c38300-e093-11eb-95af-932033002391.png)

![изображение](https://user-images.githubusercontent.com/85208391/125016367-11e58180-e093-11eb-92e1-b696d7b435f2.png)

В результате:

![изображение](https://user-images.githubusercontent.com/85208391/125016450-35103100-e093-11eb-9a45-3894066599fa.png)

![изображение](https://user-images.githubusercontent.com/85208391/125016557-5d982b00-e093-11eb-8822-01e81eae3860.png)







