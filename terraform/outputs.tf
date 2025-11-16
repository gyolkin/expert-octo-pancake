output "vm_internal_ip" {
  value = module.compute.internal_ip
}

output "vm_external_ip" {
  value = module.compute.external_ip
}

output "postgres_host" {
  value = module.postgres.host_fqdn
}

output "postgres_db_name" {
  value = module.postgres.db_name
}

output "postgres_user" {
  value = module.postgres.user_name
}

output "bucket_name" {
  value = module.storage.bucket_name
}

output "storage_service_account_id" {
  value = module.sa_storage.service_account_id
}

output "storage_access_key_id" {
  value = module.sa_storage.access_key
  sensitive = true
}

output "storage_secret_key" {
  value = module.sa_storage.secret_key
  sensitive = true
}
