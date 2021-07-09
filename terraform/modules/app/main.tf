resource "yandex_compute_instance" "app" {
<<<<<<< HEAD
name = "reddit-app"
=======
  name = "reddit-app"

>>>>>>> af3cc805d08d599d9f449d475bc1172a814d83f9
  labels = {
    tags = "reddit-app"
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
      image_id = var.app_disk_image
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
  }
  connection {
      type        = "ssh"
      host        = self.network_interface.0.nat_ip_address
      user        = "ubuntu"
      agent       = false
      private_key = file(var.private_key_path)
    }
    provisioner "file" {
    content     = "DATABASE_URL=${var.db_host}:${var.db_port}\n"
    destination = "/home/ubuntu/db.env"
  }

  provisioner "file" {
     source      = "../modules/app/files/puma.service"
     destination = "/tmp/puma.service"
   }

   provisioner "remote-exec" {
     script = "../modules/app/files/deploy.sh"
   }
 }
=======
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}
>>>>>>> af3cc805d08d599d9f449d475bc1172a814d83f9
