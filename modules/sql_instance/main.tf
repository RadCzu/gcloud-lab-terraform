
resource "google_sql_database_instance" "postgres" {
  name = "postgres"
  region = "us-central1"
  database_version = "POSTGRES_15"
  root_password = var.FRUITS_ROOT_PASS

  settings {
    tier = "db-f1-micro"
  }

  deletion_protection = false

  lifecycle {
    create_before_destroy = true
  }
}