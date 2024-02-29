output "resource_group_name" {
  value = azurerm_resource_group.lindo.name
}

output "acr_name" {
  value = azurerm_container_registry.lindoacr.name
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

output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_cluster_kube_config" {
  value = data.azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
