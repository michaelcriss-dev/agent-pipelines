variable "vm_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "size" {
  default = "Standard_B1s"
}
variable "admin_username" {}
variable "nic_id" {}
 
variable "image_rg" {
  default = "rg-packer"
}
variable "image_name" {
  default = "build-image"
}

variable "source_file" {
}

variable "destination" {
}


variable "agent_name" {
}

variable "ssh_public_key" {
}

variable "ssh_private_key" {
}

variable "DOCKER_PASS" {
}

variable "DOCKER_USER" {
}

variable "ARM_CLIENT_ID" {
}

variable "ARM_CLIENT_SECRET" {
}

variable "ARM_TENANT_ID" {
}

variable "ADMIN_PASSWORD" {
}