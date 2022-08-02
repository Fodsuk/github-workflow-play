output "policies" {
  value = [for policy in azurerm_policy_definition.schroders : {
    name         = policy.name
    display_name = policy.display_name
    mode         = policy.mode
  }]
}

output "policy_sets" {
  value = [for policy in azurerm_policy_set_definition.schroders : {
    name         = policy.name
    display_name = policy.display_name
  }]
}