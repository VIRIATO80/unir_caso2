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