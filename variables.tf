variable "FRUITS_ROOT_PASS" {
  description = "The database root password"
  type        = string
  sensitive   = true
}

variable "DOCKER_USERNAME" {
  description = "Docker Hub username"
}

variable "GITHUB_PAT" {
  description = "GitHub PAT used as Docker password"
  sensitive   = true
}

variable "project" {
  description = "project ID for GKE"
  type        = string
  default     = "devopstraining-459716"
}

variable "TF_SA_ACCESS_TOKEN" {
  description = "GCloud terraform-sa access token"
  sensitive   = true
}