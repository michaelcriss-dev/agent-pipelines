module "network" {
  source               = "../modules/network-module"

  resource_group_name  = "build-agent"
  location             = "Canada Central"
  prefix               = "build-agent"
  address_space        = ["10.0.0.0/16"]
  address_prefixes     = ["10.0.1.0/24"]
}

module "networking" {
  source              = "../modules/networking-module"

  resource_group_name = module.network.resource_group_name
  location            = "Canada Central"
  prefix              = "agent"
  subnet_id           = module.network.subnet_id
}

module "Build_Agent" {
  source                     = "../modules/vm-module"
  
  vm_name                    = "build-agent-vm"
  resource_group_name        = module.network.resource_group_name
  location                   = "Canada Central"
  admin_username             = "azureuser"
  nic_id                     = module.networking.nic_id
  ssh_public_key             = var.ssh_public_key
  ssh_private_key            = var.ssh_private_key
}
 