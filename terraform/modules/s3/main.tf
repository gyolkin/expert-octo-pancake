terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

resource "yandex_storage_bucket" "this" {
  bucket = var.bucket_name
  access_key = var.access_key
  secret_key = var.secret_key
}
