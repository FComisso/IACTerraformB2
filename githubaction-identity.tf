


resource "azuread_application" "auth" {
  display_name = "auth"
   owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "auth" {
  client_id = azuread_application.auth.client_id
}

resource "random_string" "password" {
  length = 16
  special = true
  override_special = "/@\" "
}

resource "azuread_service_principal_password" "auth" {
  service_principal_id = azuread_service_principal.auth.id
  //value                = "${random_string.password.result}"
  end_date_relative    = "240h"
}

output "client_secret" {
  value = "${random_string.password.result}"
  description = "Client Secret"
}


data "azurerm_subscription" "primary" {}


resource "azurerm_role_assignment" "auth" {
  scope                = "${data.azurerm_subscription.primary.id}"
  role_definition_name = "Contributor"
  principal_id         = "${azuread_service_principal.auth.id}"
}
