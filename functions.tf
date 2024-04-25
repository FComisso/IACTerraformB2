

resource "azurerm_application_insights" "ai" {
  name                = "${var.prefix}ai"
  location            =  azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

resource "azurerm_service_plan" "example" {
  name                = "${var.prefix}-sp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "S1"
  provider            = azurerm.azurerm_profile
}

resource "azurerm_linux_function_app" "example" {
  provider            = azurerm.azurerm_profile
  name                = "${var.prefix}-python-example-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.example.id

  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key

  # New flag to set public network access
  #public_network_access_enabled = false

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
    APPINSIGHTS_INSTRUMENTATIONKEY = "${azurerm_application_insights.ai.instrumentation_key}"
  }
  site_config {
    application_stack {
      python_version = "3.11"
    }
    cors {      
      allowed_origins = ["https://localhost:5173"]
    }
  }
}
resource "azurerm_app_service_virtual_network_swift_connection" "example" {
  app_service_id = azurerm_linux_function_app.example.id
  subnet_id      = azurerm_subnet.my_terraform_subnet_2.id
}
output "site_credential" {
  value = nonsensitive(azurerm_linux_function_app.example.site_credential)
}
