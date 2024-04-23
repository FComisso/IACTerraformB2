resource "azurerm_storage_account" "example" {
  name                      = "${var.prefix}storageacct"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  enable_https_traffic_only = true
  provider                  = azurerm.azurerm_profile
}



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

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key


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

output "site_credential" {
  value = nonsensitive(azurerm_linux_function_app.example.site_credential)
}

# resource "azurerm_function_app_function" "example" {
#   provider        = azurerm.azurerm_profile
#   name            = "example-python-function"
#   function_app_id = azurerm_linux_function_app.example.id
#   language        = "Python"
#   file {
#     name    = "__init__.py"
#     content = file("./SampleApp/PythonSampleApp/__init__.py")
#   }
#   test_data = file("./SampleApp/PythonSampleApp/sample.dat")
#   #  test_data = jsonencode({
#   #    "name" = "Azure"
#   #  })
#   config_json = file("./SampleApp/PythonSampleApp/function.json")
#   #  config_json = jsonencode({
#   #    "scriptFile" = "__init__.py"
#   #    "bindings" = [
#   #      {
#   #        "authLevel" = "anonymous"
#   #        "direction" = "in"
#   #        "methods" = [
#   #          "get",
#   #          "post",
#   #        ]
#   #        "name" = "req"
#   #        "type" = "httpTrigger"
#   #      },
#   #      {
#   #        "direction" = "out"
#   #        "name"      = "$return"
#   #        "type"      = "http"
#   #      },
#   #    ]
#   #  })
# } 
