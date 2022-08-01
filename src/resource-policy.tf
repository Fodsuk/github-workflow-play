resource "random_uuid" "policy_definition_name" {
  for_each = var.policies
}

resource "azurerm_policy_definition" "schroders" {
  for_each     = var.policies
  name         = random_uuid.set_definition_name[each.key].result
  display_name = jsondecode(file("${path.module}/policies/${each.value.policy_file}"))["properties"]["displayName"]
  description  = jsondecode(file("${path.module}/policies/${each.value.policy_file}"))["properties"]["description"]
  policy_type  = jsondecode(file("${path.module}/policies/${each.value.policy_file}"))["properties"]["policyType"]
  mode         = jsondecode(file("${path.module}/policies/${each.value.policy_file}"))["properties"]["mode"]

  metadata    = jsondecode(file("${path.module}/policies/${each.value.policy_file}"))["properties"]["metadata"]
  parameters  = jsondecode(file("${path.module}/policies/${each.value.policy_file}"))["properties"]["parameters"]
  policy_rule = jsondecode(file("${path.module}/policies/${each.value.policy_file}"))["properties"]["policy_rule"]

  lifecycle {
    //https://github.com/hashicorp/terraform-provider-azurerm/issues/15615
    create_before_destroy = true
  }
}




/*
resource "azurerm_policy_definition" "policy" {
  name                = "accTestPolicy"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "acceptance test policy definition"
  management_group_id = "/providers/Microsoft.Management/managementGroups/roddas-plt-dev-grp"

  metadata = <<METADATA
    {
    "category": "General"
    }

METADATA

  policy_rule = <<POLICY_RULE
  {
   "if":{
      "allOf":[
         {
            "field":"type",
            "equals":"Microsoft.Sql/servers"
         },
         {
            "field":"kind",
            "notContains":"analytics"
         }
      ]
   },
   "then":{
      "effect":"[parameters('effect')]",
      "details":{
         "type":"Microsoft.Sql/servers/auditingSettings",
         "name":"default",
         "existenceCondition":{
            "field":"Microsoft.Sql/auditingSettings.state",
            "equals":"[parameters('setting')]"
         }
      }
   }
  }
POLICY_RULE


  parameters = <<PARAMETERS
    {
      "effect": {
        "type": "String",
        "metadata": {
          "displayName": "Effect",
          "description": "Enable or disable the execution of the policy"
        },
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "defaultValue": "AuditIfNotExists"
      },
      "setting": {
        "type": "String",
        "metadata": {
          "displayName": "Desired Auditing setting"
        },
        "allowedValues": [
          "enabled",
          "disabled"
        ],
        "defaultValue": "enabled"
      }
    }
PARAMETERS

}

resource "azurerm_management_group_policy_assignment" "example" {
  name                 = "example-policy"
  policy_definition_id = azurerm_policy_definition.policy.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/roddas-plt-dev-grp"
}

resource "azurerm_subscription_policy_assignment" "sub_we_logged_in_as" {
  name                 = "sub_we_logged_in_as"
  policy_definition_id = azurerm_policy_definition.policy.id
  subscription_id      = "/subscriptions/daca3123-cb03-43cb-9f77-b53dd720498b"
}

resource "azurerm_subscription_policy_assignment" "sub_we_have_access_to_but_not_logged_in_as" {
  name                 = "sub_we_have_access_to_but_not_logged_in_as"
  policy_definition_id = azurerm_policy_definition.policy.id
  subscription_id      = "/subscriptions/13a19c01-9a73-4727-b914-54baa96c7924"
}
*/