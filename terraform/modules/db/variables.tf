variable cores {
  description = "Core number for instance"
  type = number
  default = 2
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}
variable subnet_id {
  description = "Subnets for modules"
}
variable private_key_path {
  description = "path to private key"
}
variable enable_provision {
  description = "Enable provisioner"
  default     = true
}
variable "public_key_path" {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable memory {
  description = "Memory GB for instance"
  type = number
  default = 2
}
variable core_fraction {
  description = "Core fraction for instance"
  type = number
  default = 50
}
