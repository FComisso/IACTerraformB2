
resource "random_uuid" "msal_api_b2_gateway_write_scope_id" {}
resource "random_uuid" "msal_api_b2_gateway_read_scope_id" {}
resource "random_uuid" "msal_api_b2_gateway_admin_app_role_id" {}
resource "random_uuid" "msal_api_b2_gateway_reader_app_role_id" {}

resource "azuread_application" "msal_api_b2_gateway" {
  display_name = "${var.prefix}msal-api-b2"
  //oauth2_allow_implicit_flow = false
  identifier_uris = ["api://api_b2_gateway_id"]
  //identifier_uris = ["api://{unique_identifier_uri}"]
  owners          = [data.azuread_client_config.current.object_id]

  sign_in_audience = "AzureADMyOrg"
  tags             = []

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "Todolist.ReadWrite.All"
    display_name         = "Todolist.ReadWrite.All"
    id                   = random_uuid.msal_api_b2_gateway_admin_app_role_id.result //id                   = "877b605d-6313-4f56-8d09-b274f60854ce"
    enabled              = true
    value                = "Todolist.ReadWrite.All"
  }

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "Allow this application to read every users Todo list items."
    display_name         = "Todolist.Read.All"
    id                   = random_uuid.msal_api_b2_gateway_reader_app_role_id.result //id                   = "751f881c-3097-4d63-b0b5-fd87281bb605"
    enabled              = true
    value                = "Todolist.Read.All"
  }



  api {
    requested_access_token_version = 2

    oauth2_permission_scope {
      admin_consent_description  = "Todolist.ReadWrite"
      admin_consent_display_name = "Todolist.ReadWrite"
      enabled                    = true
      id                         = random_uuid.msal_api_b2_gateway_write_scope_id.result
      type                       = "Admin"
      user_consent_description   = "Todolist.ReadWrite"
      user_consent_display_name  = "Todolist.ReadWrite"
      value                      = "Todolist.ReadWrite"
    }

    oauth2_permission_scope {
      admin_consent_description  = "Allow the app to read Todolist items on your behalf"
      admin_consent_display_name = "Allows to read Todolist items"
      enabled                    = true
      id                         = random_uuid.msal_api_b2_gateway_read_scope_id.result
      type                       = "User"
      user_consent_description   = "Allow the app to read Todolist items on your behalf."
      user_consent_display_name  = "Allows to read Todolist items"
      value                      = "Todolist.Read"
    }
  }

  optional_claims {
    access_token {
      name      = "acct"
      essential = false
    }
    access_token {
      name      = "idtyp"
      essential = false
    }
  }

}

resource "azuread_service_principal" "msal_api_b2_gateway" {
  client_id                    = azuread_application.msal_api_b2_gateway.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
  tags                         = ["msal_api_b2_gateway", "api"]
}




resource "azuread_application_password" "msal_api_b2_gateway" {
  application_id = azuread_application.msal_api_b2_gateway.id
  
}