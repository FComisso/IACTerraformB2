provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }
}

data "azuread_application_published_app_ids" "well_known" {}

resource "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing   = true
}
/* 
output "app_role_ids" {
  value     = azuread_service_principal.msgraph.app_role_ids
  sensitive = false
} */

data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "example" {
  name                       = "${var.prefix}keyvaultb2sky"
  resource_group_name        = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = var.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
      "List"
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List"
    ]
  }
}

resource "azurerm_key_vault_secret" "example" {
  name         = "secret-sauce"
  value        = "szechuan"
  key_vault_id = azurerm_key_vault.example.id
}



resource "azuread_application" "example" {
  display_name = "githubspb2app"
  owners       = [data.azuread_client_config.current.object_id]

#     required_resource_access {
#     resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

#     resource_access {
#       id   = azuread_service_principal.msgraph.app_role_ids["Contributor"]
#       type = "Role"
#     }

#   }
}

resource "azuread_service_principal" "example" {
  client_id                    = azuread_application.example.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]

  use_existing   = true
  feature_tags {
    enterprise = true
    gallery    = true
  }
}

/* resource "azurerm_role_assignment" "example" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.example.object_id
}  */

# resource "azuread_app_role_assignment" "example" {
#   app_role_id         = azuread_service_principal.msgraph.app_role_ids["Contributor"]
#   principal_object_id = azuread_service_principal.example.object_id
#   resource_object_id  = azuread_service_principal.msgraph.object_id
# }

# Create Service Principal password
resource "azuread_application_password" "example" {
  application_id  = azuread_application.example.id
  //value                 = "MySecretPassword"
  end_date              = "2099-01-01T00:00:00Z"
}
data "azurerm_subscription" "primary2" {}

resource "azurerm_role_assignment" "example" {
  scope                = "${data.azurerm_subscription.primary2.id}"
  role_definition_name = "Contributor"
  principal_id         = "${azuread_service_principal.example.id}"
}

# Output the Service Principal and password
output "sp" {
  value     = azuread_service_principal.example.id
  sensitive = true
}

output "sp_password" {
  value     = azuread_application_password.example.value
  sensitive = true
}

output "secret_value" {
  value = nonsensitive(azuread_application_password.example.value)
}

/* resource "azurerm_key_vault_access_policy" "example" {
  key_vault_id = azurerm_key_vault.example.id
  tenant_id    = var.tenant_id
  object_id    = "<service_principal_object_id>"

  key_permissions    = ["get", "list"]
  secret_permissions = ["get", "list"]
} */