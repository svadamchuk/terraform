locals {
  # If workspace is default, use value from var.environment_name
  environment = terraform.workspace == "default" ? var.environment_name : terraform.workspace
  config      = var.environment_configs[local.environment]

}
