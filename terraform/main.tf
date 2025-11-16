terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  folder_id = var.folder_id
  zone = var.zone
}

module "network" {
  source = "./modules/network"
  name_prefix = var.name_prefix
  zone = var.zone
  subnet_cidr = var.subnet_cidr
}

module "sa_storage" {
  source = "./modules/account"
  folder_id = var.folder_id
  name_prefix = var.name_prefix
}

module "storage" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
  access_key = module.sa_storage.access_key
  secret_key = module.sa_storage.secret_key
}

module "postgres" {
  source = "./modules/postgres"
  folder_id = var.folder_id
  name_prefix = var.name_prefix
  network_id = module.network.network_id
  subnet_id = module.network.subnet_id
  zone = var.zone
  db_password = var.postgres_password
}

module "compute" {
  source = "./modules/compute"
  name_prefix = var.name_prefix
  zone = var.zone
  subnet_id = module.network.subnet_id
  image_id = var.image_id
  vm_ssh_user = var.vm_ssh_user
  ssh_public_key_path = var.ssh_public_key_path
}
