terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

resource "yandex_mdb_postgresql_cluster" "this" {
  name = "${var.name_prefix}-pg"
  folder_id = var.folder_id
  environment = "PRESTABLE"
  network_id = var.network_id

  config {
    version = "16"

    resources {
      resource_preset_id = "s2.micro"
      disk_type_id = "network-ssd"
      disk_size = 16
    }
  }

  host {
    zone = var.zone
    subnet_id = var.subnet_id
  }
}

resource "yandex_mdb_postgresql_database" "this" {
  cluster_id = yandex_mdb_postgresql_cluster.this.id
  name = "appdb"
  owner = "postgres"
}

resource "yandex_mdb_postgresql_user" "this" {
  cluster_id = yandex_mdb_postgresql_cluster.this.id
  name = "${var.name_prefix}_user"
  password = var.db_password
  login = true
  grants = []

  permission {
    database_name = yandex_mdb_postgresql_database.this.name
  }

  settings = {
    log_min_duration_statement = "5000"
    default_transaction_isolation = "read committed"
  }
}
