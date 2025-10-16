variable "ssh_public_key" {}
variable "ssh_private_key" {}
variable "DOCKER_PASS" {}
variable "DOCKER_USER" {}
variable "ARM_CLIENT_ID" {}
variable "ARM_CLIENT_SECRET" {}
variable "ARM_TENANT_ID" {}
variable "ADMIN_PASSWORD" {}

variable "resource_group_name" {
    type = string
    default = "build-agent"
} 

variable "location" {
    type = string
    default = "Canada Central"
} 

variable "agent_name" {
    type = string
    default = "build-agent"
}

variable "admin_username" {
    type = string
    default = "azureuser"
}