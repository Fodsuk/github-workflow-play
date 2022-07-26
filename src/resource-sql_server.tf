resource "azurerm_mssql_server" "example" {
  name                         = "schroderssql"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "test"
  administrator_login_password = random_string.sql_password.result
  minimum_tls_version          = "1.2"
}

resource "random_string" "sql_password" {
  length  = 24
  special = false
  numeric = false
}
