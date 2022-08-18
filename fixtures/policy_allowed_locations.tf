resource "random_string" "allowed_locations_assignment_name" {
  length  = 20
  special = false
}

resource "azurerm_resource_group" "allowed_locations_assignment" {
  name     = "policy-ci-allowed-locations-${random_string.allowed_locations_assignment_name.result}"
  location = "UK South"
}

output "allowed_locations_assignment_resource_group_id" {
  value = azurerm_resource_group.allowed_locations_assignment.id
}