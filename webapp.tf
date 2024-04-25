

/*
resource "azurerm_app_service" "webapp" {
  name                = "${var.prefix}-webapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.webapp_plan.id

  site_config {
    app_command_line = ""
  }

  app_settings = {
    "WEBSITE_PYTHON_VERSION" = "3.11"
    "FLASK_APP"              = "app.py"
    "FLASK_ENV"              = "production"
  }

  identity {
    type = "SystemAssigned"
  }

  //    depends_on = [azurerm_app_service_slot.webapp_slot]
}*/


/*
resource "azurerm_app_service_plan" "webapp_plan" {
  name                = "${var.prefix}-app-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}*/
/*
resource "azurerm_service_plan" "webapp_plan" {
  name                = "${var.prefix}-app-service-plan-linux"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}
*/
/*
resource "azurerm_app_service_slot" "webapp_slot" {
  name                = "${var.prefix}-webapp-slot"
  app_service_name    = azurerm_app_service.webapp.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.webapp_plan.id
}*/

/*

resource "azurerm_linux_web_app_slot" "webapp_slot" {
    name                = "${var.prefix}-linux-webapp-slot"
    app_service_id      = azurerm_linux_web_app.webapp.id

    site_config {
    }

    app_settings = {
        "WEBSITE_PYTHON_VERSION" = "3.11"
        "FLASK_APP"              = "app.py"
        "FLASK_ENV"              = "production"
    }
}

resource "azurerm_linux_web_app" "webapp" {
  name                =  "${var.prefix}-linux-webapp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.webapp_plan.id

  site_config {}
}

*/
