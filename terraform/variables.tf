variable "folder_id" {
  type = string
}

variable "zone" {
  type = string
  default = "ru-central1-d"
}

variable "name_prefix" {
  type = string
  default = "demo"
}

variable "subnet_cidr" {
  type = string
  default = "10.0.0.0/24"
}

variable "image_id" {
  type = string
}

variable "vm_ssh_user" {
  type = string
  default = "ubuntu"
}

variable "ssh_public_key_path" {
  type = string
}

variable "postgres_password" {
  type = string
  sensitive = true
}

variable "bucket_name" {
  type = string
}
