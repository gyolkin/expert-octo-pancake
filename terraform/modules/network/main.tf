terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

resource "yandex_vpc_network" "this" {
  name = "${var.name_prefix}-network"
}

resource "yandex_vpc_subnet" "this" {
  name = "${var.name_prefix}-subnet"
  zone = var.zone
  network_id = yandex_vpc_network.this.id
  v4_cidr_blocks = [var.subnet_cidr]
}
