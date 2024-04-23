# Create an Azure Search service
resource "azurerm_search_service" "search_service" {
  name                = "${var.prefix}-search-service"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"

  tags = {
    environment = "test"
    purpose     = "Pulumi AI Sample"
  }
}
/* 
# Define a search index
resource "azurerm_search_index" "search_index" {
  name                = "example-search-index"
  resource_group_name = azurerm_resource_group.rg.name
  search_service_name = azurerm_search_service.search_service.name

  fields {
    name     = "id"
    type     = "Edm.String"
    key      = true
    filterable = true
  }

  fields {
    name     = "text"
    type     = "Edm.String"
    searchable = true
  }
}
 */
# Expose certain output variables
output "resource_group_id" {
  description = "The ID of the created resource group."
  value       = azurerm_resource_group.rg.id
}

output "search_service_id" {
  description = "The ID of the created search service."
  value       = azurerm_search_service.search_service.id
}

/* output "search_index_id" {
  description = "The ID of the created search index."
  value       = azurerm_search_index.search_index.id
} */