locals {
  policies = { for key, policy in var.policies : key =>
    {
      id           = azurerm_policy_definition.schroders[key].id
      name         = azurerm_policy_definition.schroders[key].name
      display_name = azurerm_policy_definition.schroders[key].display_name
      mode         = azurerm_policy_definition.schroders[key].mode
    }
  }

  policy_sets = { for key, policy_set in var.policy_sets : key =>
    {
      id           = azurerm_policy_set_definition.schroders[key].id
      name         = azurerm_policy_set_definition.schroders[key].name
      display_name = azurerm_policy_set_definition.schroders[key].display_name
      mode         = azurerm_policy_set_definition.schroders[key].mode
    }
  }

  resource_group_policy_assignments_by_policy = {
    for key, assignment in var.policy_resource_group_assignments : assignment.policy_key => {
      policy_key           = assignment.policy_key
      id                   = azurerm_resource_group_policy_assignment.schroders[key].id
      name                 = azurerm_resource_group_policy_assignment.schroders[key].name
      display_name         = azurerm_resource_group_policy_assignment.schroders[key].display_name
      resource_group_id    = azurerm_resource_group_policy_assignment.schroders[key].resource_group_id
      resource_group_name  = split("/", azurerm_resource_group_policy_assignment.schroders[key].resource_group_id)[4]
      policy_definition_id = azurerm_policy_definition.schroders[assignment.policy_key].id
    }...
  }

}
