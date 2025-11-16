terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

resource "yandex_compute_instance" "this" {
  name = "${var.name_prefix}-vm"
  platform_id = "standard-v3"
  zone = var.zone

  resources {
    cores = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat = true
  }

  metadata = {
    "ssh-keys" = "${var.vm_ssh_user}:${file(var.ssh_public_key_path)}"
  }
}
