output "b2_backend_user_api_application_secret" {
  description = "Password associated with the backend User API application."
  value       = azuread_application_password.b2_backend_user_api_pwd.value
  sensitive   = true
}