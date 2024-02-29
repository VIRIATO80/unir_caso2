resource "azurerm_network_security_group" "webserver_nsg" {
  name                = "webserver-nsg"
  location            = azurerm_resource_group.lindo.location
  resource_group_name = azurerm_resource_group.lindo.name
}

# Security group association
resource "azurerm_network_interface_security_group_association" "webserver_nsg_association" {
  network_interface_id      = azurerm_network_interface.network-nic.id
  network_security_group_id = azurerm_network_security_group.webserver_nsg.id
}

# Opening HTTP and HTTPS ports to Virtual Machine
resource "azurerm_network_security_rule" "ssh" {
      name                        = "SSH"
      priority                    = 1001
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "22"
      source_address_prefix       = "*" 
      destination_address_prefix  = "*"  
      resource_group_name         = azurerm_resource_group.lindo.name
      network_security_group_name = azurerm_network_security_group.webserver_nsg.name
}
// Http
resource "azurerm_network_security_rule" "http" {
  name                        = "http"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lindo.name
  network_security_group_name = azurerm_network_security_group.webserver_nsg.name
}

// Https Inbound
resource "azurerm_network_security_rule" "https" {
  name                        = "https"
  priority                    = 1003
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lindo.name
  network_security_group_name = azurerm_network_security_group.webserver_nsg.name
}

// Https Outbound
resource "azurerm_network_security_rule" "outbound_to_acr" {
  name                        = "outbound_to_acr"
  priority                    = 1004
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lindo.name
  network_security_group_name = azurerm_network_security_group.webserver_nsg.name
}
