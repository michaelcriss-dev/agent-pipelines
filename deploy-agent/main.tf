module "network" {
  source               = "../modules/network-module"

  resource_group_name  = var.resource_group_name
  location             = var.location
  prefix               = var.agent_name
  address_space        = ["11.0.0.0/16"]
  address_prefixes     = ["11.0.1.0/24"]
}

module "networking" {
  source              = "../modules/networking-module"

  resource_group_name = module.network.resource_group_name
  location            = var.location
  prefix              = "agent"
  subnet_id           = module.network.subnet_id
}
 
module "Deploy_Agent" {
  source                     = "../modules/vm-module"
  
  vm_name                    = "${var.agent_name}-vm"
  resource_group_name        = module.network.resource_group_name
  location                   = var.location
  admin_username             = var.admin_username
  nic_id                     = module.networking.nic_id
  source_file                = "${path.module}/scripts/${var.agent_name}.sh"
  destination                = "/tmp/${var.agent_name}.sh"
  agent_name                 = var.agent_name
  ssh_public_key             = var.ssh_public_key 
    ARM_CLIENT_ID            = var.ARM_CLIENT_ID
  ARM_CLIENT_SECRET          = var.ARM_CLIENT_SECRET
  ARM_TENANT_ID              = var.ARM_TENANT_ID
  DOCKER_PASS                = var.DOCKER_PASS
  DOCKER_USER                = var.DOCKER_USER
  ADMIN_PASSWORD             = var.ADMIN_PASSWORD
  ssh_private_key            = var.ssh_private_key 

} 
 