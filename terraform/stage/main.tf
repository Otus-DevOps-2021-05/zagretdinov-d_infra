provider "yandex" {
<<<<<<< HEAD
service_account_key_file = var.service_account_key_file
cloud_id = var.cloud_id
folder_id = var.folder_id
zone = "ru-central1-a"
=======
  version   = 0.35
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}
module "vpc" {
  source          = "../modules/vpc"
>>>>>>> af3cc805d08d599d9f449d475bc1172a814d83f9
}
module "app" {
  source          = "../modules/app"
  public_key_path = var.public_key_path
<<<<<<< HEAD
  private_key_path = var.private_key_path
  app_disk_image  = var.app_disk_image
  subnet_id = var.subnet_id
  db_port         = 27017
  }
=======
  app_disk_image  = var.app_disk_image
  subnet_id       =  module.vpc.app_subnet_id
}

>>>>>>> af3cc805d08d599d9f449d475bc1172a814d83f9
module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  db_disk_image   = var.db_disk_image
<<<<<<< HEAD
  subnet_id = var.subnet_id
=======
  subnet_id       =  module.vpc.app_subnet_id
>>>>>>> af3cc805d08d599d9f449d475bc1172a814d83f9
}
