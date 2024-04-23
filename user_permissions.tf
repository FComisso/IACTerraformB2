resource "azuread_app_role_assignment" "jane_b2_api_gateway_api_role_assignment" {
  app_role_id         = azuread_application.b2_api_gateway_api_application.app_role_ids["Reader"]
  principal_object_id = data.azuread_user.jane_user.object_id
  resource_object_id  = azuread_service_principal.b2_api_gateway_sp.object_id
}

resource "azuread_app_role_assignment" "john_b2_api_gateway_api_role_assignment" {
  app_role_id         = azuread_application.b2_api_gateway_api_application.app_role_ids["Admin"]
  principal_object_id = data.azuread_user.john_user.object_id
  resource_object_id  = azuread_service_principal.b2_api_gateway_sp.object_id
}

resource "azuread_app_role_assignment" "giuriato_b2_api_gateway_api_role_assignment" {
  app_role_id         = azuread_application.msal_api_b2_gateway.app_role_ids["Todolist.ReadWrite.All"]
  principal_object_id = data.azuread_user.giuriato_user.object_id
  resource_object_id  = azuread_service_principal.msal_api_b2_gateway.object_id
}