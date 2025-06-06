variable "FRUITS_ROOT_PASS" {
  description = "The database root password"
  type        = string
  sensitive   = true
}

variable "instance_name" {
  type = string
  description = "Instance reference"
}

variable "instance_public_ip" {
  type = string
  description = "IP of the instance"
}