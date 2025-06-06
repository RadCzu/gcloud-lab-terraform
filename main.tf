terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.35.0"
    }
  }
}

provider "google" {
  project = "devopstraining-459716"
  region  = "us-central1"
}

module "sql_instance" {
  source = "./modules/sql_instance"
  FRUITS_ROOT_PASS = var.FRUITS_ROOT_PASS
}

module "sql_database" {
  source = "./modules/sql_database"
  FRUITS_ROOT_PASS = var.FRUITS_ROOT_PASS
  instance_name = module.sql_instance.instance_name
  instance_public_ip = module.sql_instance.public_ip
  depends_on = [module.sql_instance]
}

module "app_vm" {
  source = "./modules/app"
  DOCKER_USERNAME  = var.DOCKER_USERNAME
  GITHUB_PAT = var.GITHUB_PAT
  db_host = module.sql_instance.public_ip
  depends_on = [module.sql_instance]
  project = "devopstraining-459716"
}
