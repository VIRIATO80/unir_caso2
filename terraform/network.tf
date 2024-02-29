# Network configuration

resource "azurerm_virtual_network" "network" {
  name                = "virtual-network"
  resource_group_name = azurerm_resource_group.lindo.name
  location            = azurerm_resource_group.lindo.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.lindo.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP address
resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip"
  location            = azurerm_resource_group.lindo.location
  resource_group_name = azurerm_resource_group.lindo.name
  allocation_method   = "Dynamic"
}


resource "azurerm_network_interface" "network-nic" {
  name                = "network-nic"
  location            = azurerm_resource_group.lindo.location
  resource_group_name = azurerm_resource_group.lindo.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}
