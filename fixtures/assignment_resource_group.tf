# resource "random_string" "assignment_name" {
#   length  = 20
#   special = false
# }

# resource "azurerm_resource_group" "assignment" {
#   name     = "policy-ci-policy-assignment-${random_string.assignment_name.result}"
#   location = "UK South"
# }

# output "assignment_resource_group_id" {
#   value = azurerm_resource_group.assignment.id
# }
