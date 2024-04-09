data "azuread_client_config" "current" {}

data "azuread_user" "jane_user" {
  user_principal_name = "f.comisso@clusterMWP.onmicrosoft.com"
}

data "azuread_user" "john_user" {
  user_principal_name = "m.varese@clustermwp.onmicrosoft.com"
}