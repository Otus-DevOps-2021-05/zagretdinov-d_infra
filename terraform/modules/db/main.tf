resource "yandex_compute_instance" "db" {
  name = "reddit-db"
  labels = {
    tags = "reddit-db"
  }

  resources {
    cores  = 2
    memory = 2
<<<<<<< HEAD
    core_fraction = 5
=======
>>>>>>> af3cc805d08d599d9f449d475bc1172a814d83f9
  }

  boot_disk {
    initialize_params {
      image_id = var.db_disk_image
    }
  }

  network_interface {
<<<<<<< HEAD
  subnet_id = var.subnet_id
=======
    subnet_id = var.subnet_id
>>>>>>> af3cc805d08d599d9f449d475bc1172a814d83f9
    nat = true
  }

  metadata = {
<<<<<<< HEAD
  ssh-keys = "ubuntu:${file(var.public_key_path)}"
=======
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
>>>>>>> af3cc805d08d599d9f449d475bc1172a814d83f9
  }
}
