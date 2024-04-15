resource "azurerm_api_management" "apim_service" {
      provider = azurerm.azurerm_profile
  name                = "${var.prefix}-apim-service"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "Francesco Saverio Comisso"
  publisher_email     = "f.comisso@reply.com"
  sku_name            = "Developer_1"
  tags = {
    Environment = "Demo"
  }
  policy {
    xml_content = <<XML
    <policies>
      <inbound>  
        <cors allow-credentials="true">
            <allowed-origins>
                <origin>https://api-gateway-openai-b2.developer.azure-api.net</origin>
                <origin>https://gray-water-00c212e0f.5.azurestaticapps.net/</origin>
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
        <set-backend-service id="apim-generated-policy" backend-id="api-test-sky-openai-b2-v2" />
        <validate-jwt header-name="Authorization" failed-validation-httpcode="401" 
            failed-validation-error-message="Unauthorized. Access token is missing or invalid." require-expiration-time="true">
            <openid-config url="https://login.microsoftonline.com/419624f7-52df-4ecf-a4f6-8953cabc487a/v2.0/.well-known/openid-configuration" />
            <required-claims>
                <claim name="aud" match="any">
                    <value>e7b81534-8ac0-400a-931a-a2fdbe2508a2</value>
                </claim>
            </required-claims>
        </validate-jwt> </inbound>
      <backend />
      <outbound />
      <on-error />
    </policies>
XML
  }
} 