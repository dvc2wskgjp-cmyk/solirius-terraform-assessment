
resource "azurerm_resource_group" "main" {
  name     = "rg-solirius-${var.environment}-${var.name_suffix}"
  location = var.location
}

module "app_service" {
  source = "./modules/app-service"

  app_service_sku = var.app_service_sku

  plan_name           = "asp-solirius-${var.environment}-${var.name_suffix}"
  web_app_name        = "app-solirius-${var.environment}-${var.name_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  sql_server_fqdn = module.sql_database.sql_server_fqdn
  database_name   = module.sql_database.database_name
}

module "sql_database" {
  source = "./modules/sql-database"

  database_sku = var.database_sku

  server_name         = "sql-solirius-${var.environment}-${var.name_suffix}"
  database_name       = "sqldb-solirius-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  sql_admin_username = var.sql_admin_username
  sql_admin_password = var.sql_admin_password
}
