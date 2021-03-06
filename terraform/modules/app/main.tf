resource "yandex_compute_instance" "app" {
name = "reddit-app"
  labels = {
    tags = "reddit-app"
  }

  resources {
    cores  = 2
    memory = 2
    core_fraction = 5
}
  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
    }
  }

  network_interface {
  subnet_id = var.subnet_id
  nat = true
  }
  metadata = {
  ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
      type        = "ssh"
      host        = self.network_interface.0.nat_ip_address
      user        = "ubuntu"
      agent       = false
      private_key = file(var.private_key_path)
    }
#    provisioner "file" {
#    content     = "DATABASE_URL=${var.db_host}:${var.db_port}\n"
#    destination = "/home/ubuntu/db.env"
#  }
#
#  provisioner "file" {
#     source      = "../modules/app/files/puma.service"
#     destination = "/tmp/puma.service"
#   }
#
#   provisioner "remote-exec" {
#     script = "../modules/app/files/deploy.sh"
#   }
 }
 resource "google_compute_firewall" "firewall_puma" {
   name = "allow-puma-default"
   network = "default"
   allow {
     protocol = "tcp"
     ports = ["9292", "80"]
   }
   source_ranges = ["0.0.0.0/0"]
   target_tags = ["reddit-app"]
 }
