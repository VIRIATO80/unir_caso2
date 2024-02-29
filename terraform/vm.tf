# VM based on Ubuntu
resource "azurerm_linux_virtual_machine" "linuxmachine" {
  name                = var.linux_vm_name
  resource_group_name = azurerm_resource_group.lindo.name
  location            = azurerm_resource_group.lindo.location
  size                = var.linux_vm_size
  admin_username      = var.admin_username
  disable_password_authentication = false
  network_interface_ids = [ azurerm_network_interface.network-nic.id ]
  admin_password      = var.admin_password

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer                 = "0001-com-ubuntu-server-focal"
    publisher             = "Canonical"
    sku                   = "20_04-lts-gen2"
    version               = "latest"
  }
  
}