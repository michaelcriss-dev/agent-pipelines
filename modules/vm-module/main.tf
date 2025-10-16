
data "azurerm_image" "python_build_agent" {
  name                = "agent-image"      
  resource_group_name = "rg-packer"        
}

resource "azurerm_linux_virtual_machine" "agent" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username
  network_interface_ids = [var.nic_id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  source_image_id = data.azurerm_image.python_build_agent.id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name  = var.vm_name

  provisioner "file" {
    source      = var.source_file
    destination = var.destination

    connection {
      type        = "ssh"
      host        = self.public_ip_address
      user        = var.admin_username
      private_key = var.ssh_private_key
    }
  }
  
    provisioner "remote-exec" {
    inline = [
      "export DOCKER_PASS=${var.DOCKER_PASS}",
      "export DOCKER_USER=${var.DOCKER_USER}",
      "export ARM_CLIENT_ID=${var.ARM_CLIENT_ID}",
      "export ARM_CLIENT_SECRET=${var.ARM_CLIENT_SECRET}",
      "export ARM_TENANT_ID=${var.ARM_TENANT_ID}",
      "export ADMIN_PASSWORD=${var.ADMIN_PASSWORD}",
      "chmod +x /tmp/${var.agent_name}.sh",
      "bash /tmp/${var.agent_name}.sh"
    ]
    connection {
    type        = "ssh"
    host        = azurerm_linux_virtual_machine.agent.public_ip_address
    user        = var.admin_username
    private_key = var.ssh_private_key
  }
  }
}
