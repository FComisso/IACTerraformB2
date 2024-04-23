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

variable "open_api_spec_content_format" {
  description = "The format of the content from which the API Definition should be imported. Possible values are: openapi, openapi+json, openapi+json-link, openapi-link, swagger-json, swagger-link-json, wadl-link-json, wadl-xml, wsdl and wsdl-link."
}

variable "open_api_spec_content_value" {
  description = "The Content from which the API Definition should be imported. When a content_format of *-link-* is specified this must be a URL, otherwise this must be defined inline."
}