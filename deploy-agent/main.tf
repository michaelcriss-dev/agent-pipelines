module "network" {
  source               = "../modules/network-module"

  resource_group_name  = "deploy-agent"
  location             = "Canada Central"
  prefix               = "deploy-agent"
  address_space        = ["11.0.0.0/16"]
  address_prefixes     = ["11.0.1.0/24"]
}

module "networking" {
  source              = "../modules/networking-module"

  resource_group_name = module.network.resource_group_name
  location            = "Canada Central"
  prefix              = "agent"
  subnet_id           = module.network.subnet_id
}
 
module "Deploy_Agent" {
  source                     = "../modules/vm-module"
  
  vm_name                    = "deploy-agent-vm"
  resource_group_name        = module.network.resource_group_name
  location                    = "Canada Central"
  admin_username             = "azureuser"
  nic_id                     = module.networking.nic_id
  source_file                = "${path.module}/scripts/deploy-agent.sh"
  destination                = "/tmp/deploy-agent.sh"
  agent_name                 = "deploy-agent"
  ssh_public_key             = var.ssh_public_key 
    ARM_CLIENT_ID            = var.ARM_CLIENT_ID
  ARM_CLIENT_SECRET          = var.ARM_CLIENT_SECRET
  ARM_TENANT_ID              = var.ARM_TENANT_ID
  DOCKER_PASS                = var.DOCKER_PASS
  DOCKER_USER                = var.DOCKER_USER
  ADMIN_PASSWORD             = var.ADMIN_PASSWORD
  ssh_private_key            = var.ssh_private_key 

} 
 