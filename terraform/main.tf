# Group creation
resource "azurerm_resource_group" "lindo" {
  location = var.resource_group_location
  name     = "lindo-group"
}
