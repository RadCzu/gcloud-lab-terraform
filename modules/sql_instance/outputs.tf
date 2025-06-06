output "instance_name" {
  value = google_sql_database_instance.postgres.name
}

output "public_ip" {
  value = google_sql_database_instance.postgres.ip_address[0].ip_address
}