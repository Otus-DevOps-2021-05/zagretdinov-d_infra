variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable subnet_id {
  description = "Subnets for modules"
}
variable mongod_ip {
  description = "Mongodb IP"
}
variable private_key_path {
  description = "path to private key"
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
  variable cores {
    description = "Core number for instance"
    type = number
    default = 2
  }
  variable db_host {
    description = "Database host"
    default = "127.0.0.1"
  }

  variable db_port {
    description = "Database port"
    default = 27017
  }
