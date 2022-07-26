output "sql_server_resource_group_name" {
  value = azurerm_mssql_server.schroders.resource_group_name
}

output "sql_server_minimum_tls_version" {
  value = azurerm_mssql_server.schroders.minimum_tls_version
}