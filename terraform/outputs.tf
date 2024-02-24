output "resource_group_name" {
  value = azurerm_resource_group.lindo.name
}

output "acr_name" {
  value = azurerm_container_registry.lindoacr.name
}