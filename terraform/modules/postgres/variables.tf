variable "folder_id" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "network_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "zone" {
  type = string
}

variable "db_password" {
  type = string
  sensitive = true
}
