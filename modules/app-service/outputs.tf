output "web_app_name" {
  description = "Name of the Azure App Service"
  value       = azurerm_linux_web_app.main.name
}

output "web_app_url" {
  description = "Default HTTPS URL of the deployed Web API"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "web_app_id" {
  description = "Azure resource ID of the App Service"
  value       = azurerm_linux_web_app.main.id
}
