locals {
  policies = [for policy in azurerm_policy_definition.schroders : {
    id           = policy.id
    name         = policy.name
    display_name = policy.display_name
    mode         = policy.mode
  }]

  policy_sets = [for policy_set in azurerm_policy_set_definition.schroders : {
    id           = policy_set.id
    name         = policy_set.name
    display_name = policy_set.display_name
  }]

  resource_group_policy_assignments = [for assignment in azurerm_resource_group_policy_assignment.schroders : {
    id                      = assignment.id
    name                    = assignment.name
    display_name            = assignment.display_name
    assigned_to_resource_id = assignment.resource_group_id
    policy_definition_id    = assignment.policy_definition_id
  }]

  management_group_policy_assignments = [for assignment in azurerm_management_group_policy_assignment.schroders : {
    id                      = assignment.id
    name                    = assignment.name
    display_name            = assignment.display_name
    assigned_to_resource_id = assignment.management_group_id
    policy_definition_id    = assignment.policy_definition_id
  }]

  policy_assignments = concat(local.resource_group_policy_assignments, local.management_group_policy_assignments)
}
