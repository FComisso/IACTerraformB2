resource "random_uuid" "b2_api_gateway_write_scope_id" {}
resource "random_uuid" "b2_api_gateway_read_scope_id" {}
resource "random_uuid" "b2_api_gateway_admin_app_role_id" {}
resource "random_uuid" "b2_api_gateway_reader_app_role_id" {}

resource "azuread_application" "b2_api_gateway_api_application" {
    
    display_name     = "b2-api-gateway-api"
    identifier_uris  = ["api://b2_api_gateway"]
    owners           = [data.azuread_client_config.current.object_id]

    api {
        requested_access_token_version = 2

        oauth2_permission_scope {
            admin_consent_description  = "Allow the application to access the commit multi agent llm methods"
            admin_consent_display_name = "multiagentllm.write"
            enabled                    = true
            id                         = random_uuid.b2_api_gateway_write_scope_id.result
            type                       = "Admin"
            user_consent_description  = "Allow the application to access the commit multi agent llm methods"
            user_consent_display_name  = "multiagentllm.write"
            value                      = "multiagentllm.write"
        }

        oauth2_permission_scope {
            admin_consent_description  = "Allow the application to access the read multi agent llm methods"
            admin_consent_display_name = "multiagentllm.read"
            enabled                    = true
            id                         = random_uuid.b2_api_gateway_read_scope_id.result
            type                       = "User"
            user_consent_description   = "Allow the application to access the read multi agent llm methods"
            user_consent_display_name  = "multiagentllm.read"
            value                      = "multiagentllm.read"
        }
    }

    app_role {
        allowed_member_types = ["User", "Application"]
        description          = "Can read and make b2_api_gateway"
        display_name         = "Admin"
        enabled              = true
        id                   = random_uuid.b2_api_gateway_admin_app_role_id.result
        value                = "Admin"
    }

    app_role {
        allowed_member_types = ["User", "Application"]
        description          = "Can only read b2_api_gateway"
        display_name         = "Reader"
        enabled              = true
        id                   = random_uuid.b2_api_gateway_reader_app_role_id.result
        value                = "Reader"
    }
}

resource "azuread_service_principal" "b2_api_gateway_sp" {
  client_id                    = azuread_application.b2_api_gateway_api_application.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
  tags                         = ["b2_api_gateway", "api"]
}