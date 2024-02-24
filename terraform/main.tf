resource "azurerm_resource_group" "lindo" {
  location = var.resource_group_location
  name     = "lindo-group"
}

resource "azurerm_container_registry" "lindoacr" {
  name                     = "lindoacr"
  resource_group_name      = azurerm_resource_group.lindo.name
  location                 = azurerm_resource_group.lindo.location
  sku                      = "Basic"
  admin_enabled            = true
}