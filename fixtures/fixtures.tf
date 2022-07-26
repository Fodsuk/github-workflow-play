locals {
  location = "UK South"
}
resource "random_string" "rg_name" {
  length  = 8
  special = false
  numeric = false
}

resource "azurerm_resource_group" "rg" {
  name     = "fixtures-sql-${random_string.rg_name.result}"
  location = local.location
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "location" {
  value = local.location
}
