locals {
  # Если workspace default, используем значение из var.environment_name
  environment = terraform.workspace == "default" ? var.environment_name : terraform.workspace
  config      = var.environment_configs[local.environment]

}
