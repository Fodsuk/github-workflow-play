locals {
  location = "uksouth"
  resource_group_name = "fixtures-sql${random_string.environment.result}"
}
resource "random_string" "environment" {
  length  = 8
  special = false
  numeric = false
  lower   = true
}


resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "location" {
  value = local.location
}

output "environment" {
  value = random_string.environment.result
}
