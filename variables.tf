
variable "sql_admin_username" {
  description = "SQL administrator username"
  type        = string
}

variable "sql_admin_password" {
  description = "SQL administrator password"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging or prod."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}

variable "name_suffix" {
  description = "Unique lowercase suffix for globally named Azure resources"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,12}$", var.name_suffix))
    error_message = "Use 3 to 12 lowercase letters or numbers."
  }
}

variable "app_service_sku" {
  description = "App Service Plan pricing tier"
  type        = string
  default     = "B1"
}

variable "database_sku" {
  description = "Azure SQL database pricing tier"
  type        = string
  default     = "S0"
}