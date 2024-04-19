

//terraform import azuread_service_principal.frontend_spa_serviceprincipal_b2 38ecf305-aff6-461e-8c8e-ab334545706e

resource "azuread_application" "frontend_app_spa" {
  display_name = "${var.prefix}msal-spa-b2"

  single_page_application {
    redirect_uris = [
        "https://brave-sea-0d2dc570f.5.azurestaticapps.net/",
        "https://localhost:5173/redirect/",
        "https://localhost:5173/",
        "https://gray-water-00c212e0f.5.azurestaticapps.net/redirect/",
        "https://gray-water-00c212e0f.5.azurestaticapps.net/",
        "http://localhost:3000/",
        "http://localhost:3000/redirect/"
    ]
  }
  required_resource_access {
    resource_app_id = azuread_application.msal_api_b2_gateway.client_id

    resource_access {
      id   = azuread_application.msal_api_b2_gateway.oauth2_permission_scope_ids["Todolist.ReadWrite"] //random_uuid.msal_api_b2_gateway_write_scope_id.result
      type = "Scope"
    }
    resource_access {
      id   = azuread_application.msal_api_b2_gateway.oauth2_permission_scope_ids["Todolist.Read"] //random_uuid.msal_api_b2_gateway_read_scope_id.result
      type = "Scope"
    }
  }

  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "frontend_spa_serviceprincipal_b2" {
  client_id                    = azuread_application.frontend_app_spa.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
  tags                         = ["frontend", "spa"]
}

resource "azuread_application_pre_authorized" "frontend_spa_preauthorized_b2" {
  application_id       = azuread_application.msal_api_b2_gateway.id
  authorized_client_id = azuread_application.frontend_app_spa.client_id

  permission_ids = [
    random_uuid.msal_api_b2_gateway_read_scope_id.result,
    random_uuid.msal_api_b2_gateway_write_scope_id.result
  ]
}
