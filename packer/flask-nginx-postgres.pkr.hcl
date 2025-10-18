packer {
  required_plugins {
    yandex = { version = "~> 1", source = "github.com/hashicorp/yandex" }
    ansible = { version = ">= 1.1.0", source = "github.com/hashicorp/ansible" }
  }
}

variable "folder_id"    { type = string }
variable "subnet_id"    { type = string }
variable "zone"         { type = string }
variable "image_name"   { type = string }

source "yandex" "ubuntu" {
  folder_id           = var.folder_id
  subnet_id           = var.subnet_id
  zone                = var.zone

  source_image_family = "ubuntu-2204-lts"
  ssh_username        = "ubuntu"
  use_ipv4_nat        = "true"

  image_name        = var.image_name
  image_family      = "ubuntu-2204-lts"
  image_description = "Ubuntu 22.04 with Nginx + Flask + PostgreSQL"
  disk_type         = "network-ssd"
}

build {
  name    = "yc-flask-image"
  sources = ["source.yandex.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y python3 python3-venv python3-pip git curl software-properties-common",
      "python3 -m pip install --user --upgrade pip",
      "python3 -m pip install --user ansible",
      "echo 'export PATH=$HOME/.local/bin:$PATH' | sudo tee -a /etc/profile.d/ansible.sh >/dev/null",
      ". /etc/profile.d/ansible.sh",
      "/home/ubuntu/.local/bin/ansible-galaxy collection install community.postgresql",
      "mkdir -p /tmp/app"
    ]
  }

  provisioner "file" {
    source      = "../src/expert_octo_pancake"
    destination = "/tmp/app/expert_octo_pancake"
  }

  provisioner "file" {
    source      = "../requirements.txt"
    destination = "/tmp/app/expert_octo_pancake/requirements.txt"
  }

  provisioner "ansible-local" {
    playbook_file     = "../ansible/playbooks/site.yml"
    inventory_file    = "../ansible/inventories/packer"
    role_paths        = ["../ansible/roles/common", "../ansible/roles/app", "../ansible/roles/nginx", "../ansible/roles/postgres"]
    group_vars        = "../ansible/group_vars"
    command           = "/home/ubuntu/.local/bin/ansible-playbook"
    extra_arguments = [
      "--extra-vars", "app_src=/tmp/app/expert_octo_pancake"
    ]
  }
}