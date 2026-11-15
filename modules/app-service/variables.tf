
variable "plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "web_app_name" {
  description = "Name of the Azure Linux Web App"
  type        = string
}

variable "resource_group_name" {
  description = "Azure Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sql_server_fqdn" {
  description = "Azure SQL server address"
  type        = string
}

variable "database_name" {
  description = "Application database name"
  type        = string
}
