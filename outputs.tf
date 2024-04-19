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