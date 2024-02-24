# Group creation
resource "azurerm_resource_group" "lindo" {
  location = var.resource_group_location
  name     = "lindo-group"
}

#ACR Registry creation
resource "azurerm_container_registry" "lindoacr" {
  name                     = "lindoacr"
  resource_group_name      = azurerm_resource_group.lindo.name
  location                 = azurerm_resource_group.lindo.location
  sku                      = "Basic"
  admin_enabled            = true
}

# Create of docker image and push to ACR
resource "null_resource" "upload_image_to_acr" {
  provisioner "local-exec" {
    command = "docker build -t lindoacr.azurecr.io/hello-world-example:casopractico2 ../hello-world && az acr login --name lindoacr && docker push lindoacr.azurecr.io/hello-world-example:casopractico2"
  }

  depends_on = [azurerm_container_registry.lindoacr]
}


# Network configuration
resource "azurerm_virtual_network" "network" {
  name                = "virtual-network"
  resource_group_name = azurerm_resource_group.lindo.name
  location            = azurerm_resource_group.lindo.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "network" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.lindo.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "network" {
  name                = "network-nic"
  location            = azurerm_resource_group.lindo.location
  resource_group_name = azurerm_resource_group.lindo.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.network.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }  
}

resource "azurerm_network_security_group" "webserver_nsg" {
  name                = "webserver-nsg"
  location            = azurerm_resource_group.lindo.location
  resource_group_name = azurerm_resource_group.lindo.name
}

# Public IP address
resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip"
  location            = azurerm_resource_group.lindo.location
  resource_group_name = azurerm_resource_group.lindo.name
  allocation_method   = "Dynamic"
}

# SSH key 
resource "azurerm_ssh_public_key" "key" {
  name                = "sshkey"
  location            = azurerm_resource_group.lindo.location
  resource_group_name = azurerm_resource_group.lindo.name
  public_key          = file(var.ssh_public_key_path)
}


# Opening SSH, HTTP and HTTPS ports to Virtual Machine

// SSH
resource "azurerm_network_security_rule" "ssh" {
  name                        = "ssh"
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

// Https
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


# Security group
resource "azurerm_network_interface_security_group_association" "webserver_nsg_association" {
  network_interface_id      = azurerm_network_interface.network.id
  network_security_group_id = azurerm_network_security_group.webserver_nsg.id
}


# VM based on Ubuntu
resource "azurerm_linux_virtual_machine" "linuxmachine" {
  name                = var.linux_vm_name
  resource_group_name = azurerm_resource_group.lindo.name
  location            = azurerm_resource_group.lindo.location
  size                = var.linux_vm_size
  admin_username      = var.admin_username
  disable_password_authentication = true
  network_interface_ids = [azurerm_network_interface.network.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = azurerm_ssh_public_key.key.public_key
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

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "lindo-aks-cluster"
  location            = azurerm_resource_group.lindo.location
  resource_group_name = azurerm_resource_group.lindo.name
  dns_prefix          = "lindo-aks-cluster"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_DS2_v2"
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}


# Get AKS Credentials
data "azurerm_kubernetes_cluster" "aks" {
  name                = azurerm_kubernetes_cluster.aks_cluster.name
  resource_group_name = azurerm_resource_group.lindo.name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
  username               = data.azurerm_kubernetes_cluster.aks.kube_config.0.username
  password               = data.azurerm_kubernetes_cluster.aks.kube_config.0.password
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}