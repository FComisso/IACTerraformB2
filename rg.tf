resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-resources"
  location = var.location
  provider = azurerm.azurerm_profile
} 