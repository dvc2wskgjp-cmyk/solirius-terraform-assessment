
resource "azurerm_resource_group" "main" {
  name     = "rg-solirius-assessment"
  location = "uksouth"
}

module "app_service" {
  source = "./modules/app-service"

  plan_name           = "asp-solirius-assessment"
  web_app_name        = "app-solirius-steven-demo"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  sql_server_fqdn = module.sql_database.sql_server_fqdn
  database_name   = module.sql_database.database_name
}

module "sql_database" {
  source = "./modules/sql-database"

  server_name         = "sql-solirius-steven-demo"
  database_name       = "sqldb-solirius-demo"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  sql_admin_username = var.sql_admin_username
  sql_admin_password = var.sql_admin_password
}
