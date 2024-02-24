output "resource_group_name" {
  value = azurerm_resource_group.lindo.name
}

output "acr_name" {
  value = azurerm_container_registry.lindoacr.name
}

output "docker_image_name" {
  value = "hello-world-example:casopractico2"
}

output "acr_repository_url" {
  value = azurerm_container_registry.lindoacr.login_server
}

output "network_interface_name" {
  value = azurerm_network_interface.network.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.network.name
}

output "linux_vm_name" {
  value = azurerm_linux_virtual_machine.linuxmachine.name
}
