resource "random_string" "vnet_name" {
  length  = 20
  special = false
}

resource "azurerm_resource_group" "vnet" {
  name     = "policy-ci-${random_string.vnet_name.result}"
  location = "UK South"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "policy-ci-${random_string.vnet_name.result}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name
}

resource "azurerm_subnet" "pli_subnet" {
  name                 = "policy-ci-pli-${random_string.vnet_name.result}"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

output "private_link_endpoint_subnet_id" {
  value = azurerm_subnet.pli_subnet.id
}