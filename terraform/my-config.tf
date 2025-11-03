variable "image-id" {
  type = string
}

variable "ssh-key" {
  type = string
}

variable "subnet-id" {
  type = string
}

variable "network-id" {
  type = string
}

resource "yandex_compute_instance" "vm-1" {
  name        = "from-terraform-vm"
  platform_id = "standard-v3"
  zone        = "ru-central1-d"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image-id
    }
  }

  network_interface {
    subnet_id = var.subnet-id
    nat       = true
  }

  metadata = {
    "ssh-keys" = "ubuntu:${file(var.ssh-key)}"
  }
}

resource "yandex_mdb_postgresql_cluster" "postgres-1" {
  name        = "postgres-1"
  environment = "PRESTABLE"
  network_id  = var.network-id

  config {
    version = 16

    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 16
    }

    postgresql_config = {
      max_connections                   = 395
      enable_parallel_hash              = true
      autovacuum_vacuum_scale_factor    = 0.34
      default_transaction_isolation     = "TRANSACTION_ISOLATION_READ_COMMITTED"
      shared_preload_libraries          = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
    }
  }

  database {
    name  = "postgres-1"
    owner = "my-name"
  }

  user {
    name       = "my-name"
    password   = "Test1234"
    conn_limit = 50

    permission {
      database_name = "postgres-1"
    }

    settings = {
      default_transaction_isolation = "read committed"
      log_min_duration_statement    = 5000
    }
  }

  host {
    zone      = "ru-central1-d"
    subnet_id = var.subnet-id
  }
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}
