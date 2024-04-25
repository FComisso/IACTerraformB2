
resource "random_id" "cognitive" {
  byte_length = 6
}

# Cognitive Services
resource "azurerm_cognitive_account" "cognitive1" {
  name                = "${var.prefix}-oai-${random_id.cognitive.hex}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "S0"
  kind                = "OpenAI"

  count = 1

  custom_subdomain_name = "oai-${random_id.cognitive.hex}"

  network_acls {
    default_action = "Deny"
    virtual_network_rules {
      subnet_id = azurerm_subnet.my_terraform_subnet_1.id
    }

  }
}

# Cognitive Deployments 
resource "azurerm_cognitive_deployment" "gpt-35-turbo" {
  name                 = "gpt-35-turbo"
  cognitive_account_id = azurerm_cognitive_account.cognitive1[0].id
  model {
    format = "OpenAI"
    name   = "gpt-35-turbo"
    version = "1106"
    # 4 1106 perv
  }
  scale {
    type = "Standard"
  }
}

# resource "azurerm_cognitive_deployment" "gpt-4-preview" {
#   name                 = "gpt-4-preview"
#   cognitive_account_id = azurerm_cognitive_account.cognitive1[0].id
#   model {
#     format = "OpenAI"
#     name   = "gpt-4-1106-preview"
#   }
#   scale {
#     type = "Standard"
#   }
# }

resource "azurerm_private_endpoint" "example-pe01" {
  name                = "${var.prefix}-pe-openai-we"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.my_terraform_subnet_1.id


  private_service_connection {
    name                           = "${var.prefix}-pe-openai-we"
    private_connection_resource_id = azurerm_cognitive_account.cognitive1[0].id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.example.id]
  }
}

resource "azurerm_private_dns_zone" "example" {
  name                = "privatelink.openai.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "example-vnet-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = azurerm_virtual_network.my_terraform_network.id
}