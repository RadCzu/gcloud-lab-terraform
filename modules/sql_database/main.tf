
resource "google_sql_database" "fruitsdb" {
  name = "fruitsdb"
  instance = var.instance_name
}

# database polulation
# resource "null_resource" "populate_fruitsdb" {
#   provisioner "local-exec" {
#     interpreter = ["PowerShell", "-Command"]
#     command = "psql -h ${var.instance_public_ip} -U postgres -d fruitsdb -f 'C:/Users/Radek/Radek/radek rc/Uczelniane/Epolog/DevOps/Database/db.sql'"
#     environment = {
#       PGPASSWORD = var.FRUITS_ROOT_PASS
#     }
#   }
# }

