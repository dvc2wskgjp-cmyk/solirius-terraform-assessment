
variable "server_name" {
  type        = string
  description = "Azure SQL logical server name"
}

variable "database_name" {
  type        = string
  description = "Azure SQL database name"
}

variable "resource_group_name" {
  type        = string
  description = "Azure resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "sql_admin_username" {
  type        = string
  description = "SQL administrator username"
}

variable "sql_admin_password" {
  type        = string
  description = "SQL administrator password"
  sensitive   = true
}
