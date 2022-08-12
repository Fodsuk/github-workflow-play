resource "random_string" "sql_server_name" {
  length  = 20
  special = false
  upper   = false
}

resource "random_password" "sql_password" {
  length           = 20
  special          = true
  override_special = "~!@#$%^&"
}

resource "azurerm_resource_group" "sql_resource_group" {
  name     = "policy-ci-sql_server-${random_string.sql_server_name.result}"
  location = "UK South"
}

resource "azurerm_mssql_server" "sql_server" {
  name                          = "sql-fixture-${random_string.sql_server_name.result}"
  resource_group_name           = azurerm_resource_group.sql_resource_group.name
  location                      = azurerm_resource_group.sql_resource_group.location
  version                       = "12.0"
  administrator_login           = "sqlfixturetest"
  administrator_login_password  = "fix${random_password.sql_password.result}"
  public_network_access_enabled = false
}

output "sql_server_resource_group_id" {
  value = azurerm_resource_group.sql_resource_group.id
}

output "sql_server_id" {
  value = azurerm_mssql_server.sql_server.id
}