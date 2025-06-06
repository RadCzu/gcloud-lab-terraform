variable "DOCKER_USERNAME" {
  description = "Docker Hub username"
}

variable "GITHUB_PAT" {
  description = "GitHub PAT used as Docker password"
  sensitive   = true
}

variable "db_host" {
  type        = string
  description = "IP address of the Cloud SQL instance"
}

variable "project" {
  type        = string
  description = "project name"
}