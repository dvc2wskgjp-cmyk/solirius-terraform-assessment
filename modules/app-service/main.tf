
resource "azurerm_service_plan" "main" {
  name                = var.plan_name
  resource_group_name = var.resource_group_name
  location            = var.location

  os_type  = "Linux"
  sku_name = "B1"
}

resource "azurerm_linux_web_app" "main" {
  name                = var.web_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id

  https_only = true

  app_settings = {
    "Database__Server" = var.sql_server_fqdn
    "Database__Name"   = var.database_name
  }
  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
  }
}
