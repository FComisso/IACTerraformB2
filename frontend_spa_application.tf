resource "azuread_application" "frontend_spa_application" {   
    display_name     = "b2-frontend-spa"
    owners           = [data.azuread_client_config.current.object_id]

    single_page_application {
        redirect_uris = ["https://brave-sea-0d2dc570f.5.azurestaticapps.net/"]
    }

    required_resource_access {
        resource_app_id = azuread_application.b2_api_gateway_api_application.client_id

        resource_access {
            id   = azuread_application.b2_api_gateway_api_application.oauth2_permission_scope_ids["multiagentllm.read"]
            type = "Scope"
        }
    }
}

resource "azuread_service_principal" "frontend_spa_sp" {
  client_id                    = azuread_application.frontend_spa_application.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
  tags                         = ["frontend", "spa"]
}


resource "azuread_application_pre_authorized" "frontend_spa_preauthorized" {
  application_id       = azuread_application.b2_api_gateway_api_application.id
  authorized_client_id = azuread_application.frontend_spa_application.client_id

  permission_ids = [
    random_uuid.b2_api_gateway_read_scope_id.result
  ]
}