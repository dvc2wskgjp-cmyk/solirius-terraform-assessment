
variable "sql_admin_username" {
  description = "SQL administrator username"
  type        = string
}

variable "sql_admin_password" {
  description = "SQL administrator password"
  type        = string
  sensitive   = true
}
