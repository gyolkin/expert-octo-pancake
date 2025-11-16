output "cluster_id" {
  value = yandex_mdb_postgresql_cluster.this.id
}

output "host_fqdn" {
  value = yandex_mdb_postgresql_cluster.this.host[0].fqdn
}

output "db_name" {
  value = yandex_mdb_postgresql_database.this.name
}

output "user_name" {
  value = yandex_mdb_postgresql_user.this.name
}
