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

variable "ssh_public_key" {
}

variable "ssh_private_key" {
}