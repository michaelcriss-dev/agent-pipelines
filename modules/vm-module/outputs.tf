output "vm_id" {
  value = azurerm_linux_virtual_machine.agent.id
}

output "vm_ip" {
  value = azurerm_linux_virtual_machine.agent.public_ip_address
}

output "vm_ip" {
  value = azurerm_linux_virtual_machine.agent.admin_username
}