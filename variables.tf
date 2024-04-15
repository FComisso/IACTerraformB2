variable "master_application_client_id" {
    description ="Application ID of the master app used to create the resources on Entra."
    type = string
}

variable "master_application_client_secret" {
    description ="Application secret of the master app used to create the resources on Entra."
    type = string
}

variable "tenant_id" {
    description ="The ID of your Entra Tenant."
    type = string
}

variable "apim_name" {
    description ="The Name of The API Management instance."
    type = string
}

variable "prefix" {
  type        = string
  description = "The prefix used for all resources in this example"
}

variable "location" {
  type        = string
  description = "The Azure location where all resources in this example should be created"
}

variable "subscription_id" {
  type        = string
  description = "Sub Id"
}