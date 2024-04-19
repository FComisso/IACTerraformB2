/* resource "azuread_application" "b2_backend_user_api_application" {
    
    display_name     = "b2-backend-user-api"
    identifier_uris  = ["api://b2backenduserapi"]
    owners           = [data.azuread_client_config.current.object_id]

    api {
        requested_access_token_version = 2
    }

    required_resource_access {
        resource_app_id = azuread_application.b2_api_gateway_api_application.client_id

        resource_access {
            id   = azuread_application.b2_api_gateway_api_application.app_role_ids["Reader"]
            type = "Role"
        }
    }
}

resource "azuread_application_password" "b2_backend_user_api_pwd" {
  application_id        = azuread_application.b2_backend_user_api_application.id
  display_name          = "Terraform Managed Password"
  end_date              = "2099-01-01T01:02:03Z"
}

resource "azuread_service_principal" "b2_backend_user_sp" {
  client_id                    = azuread_application.b2_backend_user_api_application.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
  tags                         = ["b2_backend_user_", "api"]
} */