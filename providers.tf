terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.45.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.95.0"
    }
    time = {
      source = "hashicorp/time"
      # Setting the provider version is a strongly recommended practice
       version = "0.11.1"
    }
  }
}

provider "time" {
  # Configuration options
}

provider "azuread" {
  client_id     = var.master_application_client_id
  client_secret = var.master_application_client_secret
  tenant_id     = var.tenant_id
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  alias           = "azurerm_profile"
  subscription_id = var.subscription_id 
  client_id       = var.master_application_client_id
  client_secret   =  var.master_application_client_secret
  tenant_id       = var.tenant_id
  skip_provider_registration = true
}