resource "random_uuid" "policy_definition_name" {
  for_each = var.policies
}

resource "azurerm_policy_definition" "schroders" {
  for_each     = var.policies
  name         = random_uuid.policy_definition_name[each.key].result
  display_name = jsondecode(file("${path.module}/policies/${each.value.policy_file}"))["properties"]["displayName"]
  description  = jsondecode(file("${path.module}/policies/${each.value.policy_file}"))["properties"]["description"]
  policy_type  = jsondecode(file("${path.module}/policies/${each.value.policy_file}"))["properties"]["policyType"]
  mode         = jsondecode(file("${path.module}/policies/${each.value.policy_file}"))["properties"]["mode"]

  metadata    = jsonencode(jsondecode(file("${path.module}/policies/${each.value.policy_file}"))["properties"]["metadata"])
  parameters  = jsonencode(jsondecode(file("${path.module}/policies/${each.value.policy_file}"))["properties"]["parameters"])
  policy_rule = jsonencode(jsondecode(file("${path.module}/policies/${each.value.policy_file}"))["properties"]["policyRule"])

  management_group_id = var.policy_scope.management_group_id

  lifecycle {
    //https://github.com/hashicorp/terraform-provider-azurerm/issues/15615
    create_before_destroy = true
  }
}