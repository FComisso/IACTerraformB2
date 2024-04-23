
resource "azurerm_api_management" "apim_service" {
  provider            = azurerm.azurerm_profile
  name                = "${var.prefix}-apim-service-3"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "Francesco Saverio Comisso"
  publisher_email     = "f.comisso@reply.com"
  sku_name            = "Developer_1"
  tags = {
    Environment = "Demo"
  }

  identity {
    type = "SystemAssigned"
  }

  protocols {
    enable_http2 = false
  }

  /*   virtual_network_type = "External"

  virtual_network_configuration {
    subnet_id = azurerm_subnet.my_terraform_subnet_1.id
  } */

}


resource "azurerm_api_management_authorization_server" "apim_auth" {

  name                         = "${var.prefix}-auth-server"
  api_management_name          = azurerm_api_management.apim_service.name
  resource_group_name          = azurerm_resource_group.rg.name
  display_name                 = "${var.prefix}-auth-server"
  authorization_endpoint       = "https://login.microsoftonline.com/${var.tenant_id}/oauth2/v2.0/authorize"
  client_id                    = azuread_application.msal_api_b2_gateway.client_id
  client_secret                = azuread_application_password.msal_api_b2_gateway.value
  client_registration_endpoint = "http://localhost"
  token_endpoint               = "https://login.microsoftonline.com/${var.tenant_id}/oauth2/v2.0/token"

  default_scope = "api://api_b2_gateway_id/.default"

  client_authentication_method = [
    "Body"
  ]

  authorization_methods = [
    "GET",
    "POST",
  ]

  bearer_token_sending_methods = [
    "authorizationHeader"
  ]

  grant_types = [
    "authorizationCode",
    # missing from azurerm provider
    #    "authorizationCodeWithPkce"
  ]
}


resource "azurerm_api_management_api" "api" {
  name                = "${var.prefix}-api"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim_service.name
  revision            = "1"
  display_name        = "${var.prefix}-api"
  path                = "api"
  protocols           = ["https"]
  description         = "An example API"
  import {
    content_format = var.open_api_spec_content_format
    content_value  = file("${var.open_api_spec_content_value}")
  }
  #  service_url                   = var.backend_url
  oauth2_authorization {
    authorization_server_name = azurerm_api_management_authorization_server.apim_auth.name
  }
}

resource "azurerm_api_management_product" "product" {
  product_id            = "${var.prefix}-product"
  resource_group_name   = azurerm_resource_group.rg.name
  api_management_name   = azurerm_api_management.apim_service.name
  display_name          = "${var.prefix}-product"
  subscription_required = true
  approval_required     = false
  published             = true
  description           = "An example Product"
}

resource "azurerm_api_management_group" "group" {
  name                = "${var.prefix}-group"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim_service.name
  display_name        = "${var.prefix}-group"
  description         = "An example group"
}

resource "azurerm_api_management_product_api" "product_api" {
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim_service.name
  product_id          = azurerm_api_management_product.product.product_id
  api_name            = azurerm_api_management_api.api.name
}

resource "azurerm_api_management_product_group" "product_group" {
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim_service.name
  product_id          = azurerm_api_management_product.product.product_id
  group_name          = azurerm_api_management_group.group.name
}

resource "azurerm_api_management_api_policy" "api_endpoint" {
  api_name            = azurerm_api_management_api.api.name
  api_management_name = azurerm_api_management.apim_service.name
  resource_group_name = azurerm_resource_group.rg.name

  xml_content = <<XML
<policies>
    <inbound>
        <!--base: Begin Global scope <base /> -->
        <cors allow-credentials="true">
            <allowed-origins>
                <origin>https://api-gateway-openai-b2.developer.azure-api.net</origin>
                <origin>https://gray-water-00c212e0f.5.azurestaticapps.net/</origin>
                <origin>https://localhost:5173</origin>
            </allowed-origins>
            <allowed-methods preflight-result-max-age="300">
                <method>*</method>
            </allowed-methods>
            <allowed-headers>
                <header>*</header>
            </allowed-headers>
            <expose-headers>
                <header>*</header>
            </expose-headers>
        </cors>
        <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">
            <openid-config url="https://login.microsoftonline.com/${var.tenant_id}/v2.0/.well-known/openid-configuration" />
            <required-claims>
                <claim name="aud">
                    <value>${azuread_application.msal_api_b2_gateway.client_id}</value>
                </claim>
            </required-claims>
        </validate-jwt>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}
