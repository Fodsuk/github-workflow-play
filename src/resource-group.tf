resource "azurerm_resource_group" "policy_identity" {
  name     = "my-resource-rg"
  location = var.location
}