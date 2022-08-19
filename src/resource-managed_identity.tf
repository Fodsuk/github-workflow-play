locals {
  # get a distinct list of all policy role names
  distinct_role_names = toset(flatten([for policy in var.policies : policy.managed_identity_required_roles if policy.managed_identity_required_roles != null]))

  identity_resource_group_name = lower("${var.system}-${var.environment}-${var.purpose}-policy_managed_identity-${var.location}")
}

resource "azurerm_resource_group" "policy_managed_identity" {
  name     = local.identity_resource_group_name
  location = var.location
}

resource "azurerm_user_assigned_identity" "policy_managed_identity" {
  name                = local.identity_resource_group_name
  resource_group_name = azurerm_resource_group.policy_managed_identity.name
  location            = azurerm_resource_group.policy_managed_identity.location
}

resource "random_uuid" "policy_managed_identity" {
  for_each = local.distinct_role_names
}

resource "azurerm_role_assignment" "policy_managed_identity" {
  for_each             = local.distinct_role_names
  name                 = random_uuid.policy_managed_identity[each.key].result
  scope                = local.policy_scope.id
  role_definition_name = each.key
  principal_id         = azurerm_user_assigned_identity.policy_managed_identity.principal_id
}

