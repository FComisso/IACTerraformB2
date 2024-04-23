
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
  }
  scale {
    type = "Standard"
  }
}