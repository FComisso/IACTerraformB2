/* output "b2_backend_user_api_application_secret" {
  description = "Password associated with the backend User API application."
  value       = azuread_application_password.b2_backend_user_api_pwd.value
  sensitive   = true
} */

# output "app_name" {
#   value = azurerm_linux_function_app.example.name
# }

# output "function_url" {
#   value = "${azurerm_function_app_function.example.invocation_url}?"
# }

output "service_id" {
  description = "The ID of the API Management Service created"
  value       = azurerm_api_management.apim_service.id
}

output "gateway_url" {
  description = "The URL of the Gateway for the API Management Service"
  value       = azurerm_api_management.apim_service.gateway_url
}

output "service_public_ip_addresses" {
  description = "The Public IP addresses of the API Management Service"
  value       = azurerm_api_management.apim_service.public_ip_addresses
}

output "api_outputs" {
  description = "The IDs, state, and version outputs of the APIs created"
  value = {
    id             = azurerm_api_management_api.api.id
    is_current     = azurerm_api_management_api.api.is_current
    is_online      = azurerm_api_management_api.api.is_online
    version        = azurerm_api_management_api.api.version
    version_set_id = azurerm_api_management_api.api.version_set_id
  }
}

output "product_ids" {
  description = "The ID of the Product created"
  value       = azurerm_api_management_product.product.id
}

output "product_api_ids" {
  description = "The ID of the Product/API association created"
  value       = azurerm_api_management_product_api.product_api.id
}

output "product_group_ids" {
  description = "The ID of the Product/Group association created"
  value       = azurerm_api_management_product_group.product_group.id
}

output "github_actions_secret-api_key" {
  description = "AZURE_STATIC_WEB_APPS_API_TOKEN"
  value       = nonsensitive(azurerm_static_web_app.test.api_key)
}