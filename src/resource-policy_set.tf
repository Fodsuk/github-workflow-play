resource "random_uuid" "set_definition_name" {
  for_each = var.policy_sets
}

locals {
  // group policies by their set
  set_policies = {
    for policy_key, policy in var.policies : policy.set_name => policy_key...
  }
}

resource "azurerm_policy_set_definition" "schroders" {
  for_each     = var.policy_sets
  name         = random_uuid.set_definition_name[each.key].result
  policy_type  = "Custom"
  display_name = each.value.display_name
  metadata     = jsonencode(each.value.metadata)

  dynamic "policy_definition_reference" {
    for_each = local.set_policies[each.key]

    content {
      policy_definition_id = azurerm_policy_definition.schroders[policy_definition_reference.value].id
      policy_group_names   = []
    }
  }

}
