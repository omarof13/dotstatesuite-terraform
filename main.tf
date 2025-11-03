terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50"
    }
  }
  required_version = ">= 1.3.0"
}

# =====================================================================
# Azure Provider Configuration
# ---------------------------------------------------------------------
# Define the Azure subscription where resources will be deployed.
# To find your subscription ID:
#   az account list --output table
# Paste your SubscriptionId value below.
# =====================================================================

provider "azurerm" {
  features {}
  subscription_id = "YOUR-SUBSCRIPTION-ID-HERE"
}

resource "azurerm_resource_group" "dotstat_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "dotstat_vnet" {
  name                = "dotstat-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.dotstat_rg.location
  resource_group_name = azurerm_resource_group.dotstat_rg.name
}

resource "azurerm_subnet" "dotstat_subnet" {
  name                 = "dotstat-subnet"
  resource_group_name  = azurerm_resource_group.dotstat_rg.name
  virtual_network_name = azurerm_virtual_network.dotstat_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "dotstat_nsg" {
  name                = "dotstat-nsg"
  location            = azurerm_resource_group.dotstat_rg.location
  resource_group_name = azurerm_resource_group.dotstat_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }

  security_rule {
    name                       = "RDP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }

  security_rule {
    name                       = "HTTP_APP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range           = "*"
    destination_port_ranges     = ["80-9000"]
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
}

resource "azurerm_public_ip" "dotstat_ip" {
  name                = "dotstat-ip"
  location            = azurerm_resource_group.dotstat_rg.location
  resource_group_name = azurerm_resource_group.dotstat_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "dotstat_nic" {
  name                = "dotstat-nic"
  location            = azurerm_resource_group.dotstat_rg.location
  resource_group_name = azurerm_resource_group.dotstat_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.dotstat_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dotstat_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "dotstat_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.dotstat_nic.id
  network_security_group_id = azurerm_network_security_group.dotstat_nsg.id
}

resource "azurerm_linux_virtual_machine" "dotstat_vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.dotstat_rg.name
  location            = azurerm_resource_group.dotstat_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.dotstat_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  computer_name = "dotstat-vm"

  custom_data = filebase64("${path.module}/cloud-init.yaml")
}

output "public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.dotstat_ip.ip_address
}
