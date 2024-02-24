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

# Provisionar la imagen al ACR usando local-exec
resource "null_resource" "upload_image_to_acr" {
  provisioner "local-exec" {
    command = "docker build -t lindoacr.azurecr.io/hello-world-example:casopractico2 ../hello-world && az acr login --name lindoacr && docker push lindoacr.azurecr.io/hello-world-example:casopractico2"
  }

  depends_on = [azurerm_container_registry.lindoacr]
}
