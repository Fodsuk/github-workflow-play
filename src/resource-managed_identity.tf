locals {
  # scope managed identity to same as the policies (be it mg or subscription)
  managed_identity_scope = coalesce(var.policy_scope.management_group_id, data.azurerm_subscription.current.id)

  # get a distinct list of all policy role names
  distinct_role_names = toset(flatten([for policy in var.policies : policy.managed_identity_required_roles if policy.managed_identity_required_roles != null]))
}

resource "azurerm_resource_group" "policy_managed_identity" {
  name     = lower("${var.system}-${var.environment}-${var.purpose}-${var.location}")
  location = var.location
}

resource "azurerm_user_assigned_identity" "policy_managed_identity" {
  name                = lower("${var.system}-${var.environment}-${var.purpose}-${var.location}-policy_assignment")
  resource_group_name = azurerm_resource_group.policy_managed_identity.name
  location            = azurerm_resource_group.policy_managed_identity.location
}

data "azurerm_subscription" "current" {}

resource "random_uuid" "policy_managed_identity" {
  for_each = local.distinct_role_names
}

resource "azurerm_role_assignment" "policy_managed_identity" {
  for_each             = local.distinct_role_names
  name                 = random_uuid.policy_managed_identity[each.key].result
  scope                = local.managed_identity_scope
  role_definition_name = each.key
  principal_id         = azurerm_user_assigned_identity.policy_managed_identity.principal_id
}

