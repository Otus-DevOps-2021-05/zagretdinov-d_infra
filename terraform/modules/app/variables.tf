variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default = "reddit-app-base"
}

variable subnet_id {
description = "Subnets for modules"
}

variable db_host {
  description = "Database host"
  default = "127.0.0.1"
}

variable db_port {
  description = "Database port"
  default = 27017
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}
