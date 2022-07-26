resource "azurerm_mssql_server" "schroders" {
  name                         = "plt-${var.environment}-${var.location}-sql"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "test"
  administrator_login_password = random_password.sql_password.result
  minimum_tls_version          = "1.2"
}

resource "random_string" "sql_password" {
  length  = 24
  special = true
  numeric = true
}

resource "random_password" "sql_password" {
  length = 16
  special = true
  override_special = "_%@"
}