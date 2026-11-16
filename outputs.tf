output "web_app_name" {
  description = "Name of the deployed Azure Web App"
  value       = module.app_service.web_app_name
}

output "web_app_url" {
  description = "HTTPS URL of the deployed Web API"
  value       = module.app_service.web_app_url
}

output "web_app_id" {
  description = "Azure resource ID of the Web App"
  value       = module.app_service.web_app_id
}