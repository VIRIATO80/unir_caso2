#ACR Registry creation
resource "azurerm_container_registry" "lindoacr" {
  name                     = "lindoacr"
  resource_group_name      = azurerm_resource_group.lindo.name
  location                 = azurerm_resource_group.lindo.location
  sku                      = "Standard"
  admin_enabled            = true
  public_network_access_enabled = true
}
