resource "random_string" "management_group_assignment_name" {
  for_each = var.policy_management_group_assignments
  length   = 20
  special  = false
}

resource "azurerm_management_group_policy_assignment" "schroders" {
  for_each     = var.policy_management_group_assignments
  name         = random_string.management_group_assignment_name[each.key].result
  display_name = each.value.display_name
  description  = each.value.description
  metadata     = jsonencode(each.value.metadata)
  parameters   = each.value.parameters_json
  location     = var.location

  policy_definition_id = azurerm_policy_definition.schroders[each.value.policy_key].id
  management_group_id  = each.value.management_group_id

  dynamic "identity" {
    for_each = each.value.managed_identity_required ? [1] : []
    content {
      type = "UserAssigned"
      identity_ids = [
        azurerm_user_assigned_identity.policy_managed_identity.principal_id
      ]
    }
  }
}
