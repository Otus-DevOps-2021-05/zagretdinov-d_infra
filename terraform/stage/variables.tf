variable "app_disk_image" {
  description = "Disk image"
}
variable "db_disk_image" {
  description = "Disk image"
}
variable "subnet_id" {
  description = "Subnet"
}
variable "public_key_path" {
description = "Path to the public key used for ssh access"
}
variable private_key_path {
  description = "Path to the private key used for ssh access"
}
variable "network_id" {
description = "Auto-created default network"
}
variable "cloud_id" {
  description = "Cloud"
}
variable "folder_id" {
  description = "Folder"
}
variable "service_account_key_file" {
  description = "key .json"
}
variable cidr {
  description = "Subnet CIDR"
}
