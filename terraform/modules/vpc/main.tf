resource "yandex_vpc_subnet" "subnet" {
  name = "reddit-subnet"
  zone = "ru.central1-a"
  network_id = var.network.id
  v4_cidr_blocks = [var.cidr]
}
