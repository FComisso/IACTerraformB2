resource "random_string" "db_account_name" {
  count   = 1
  length  = 20
  upper   = false
  special = false
  numeric = false
}

locals {
  cosmosdb_account_name = try(random_string.db_account_name[0].result, var.cosmosdb_account_name)
}

resource "azurerm_cosmosdb_account" "example" {
  name                      = local.cosmosdb_account_name
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  offer_type                = "Standard"
  kind                      = "GlobalDocumentDB"
#  enable_automatic_failover = false
  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  depends_on = [
    azurerm_resource_group.rg
  ]

  public_network_access_enabled = true
  is_virtual_network_filter_enabled = true

  virtual_network_rule {
    id = azurerm_subnet.my_terraform_subnet_1.id
  }
}

resource "azurerm_cosmosdb_sql_database" "main" {
  name                = "sky-nacl-db"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.example.name
  autoscale_settings {
    max_throughput = var.max_throughput
  }
}

resource "azurerm_cosmosdb_sql_container" "example" {
  name                  = "conversations"
  resource_group_name   = azurerm_resource_group.rg.name
  account_name          = azurerm_cosmosdb_account.example.name
  database_name         = azurerm_cosmosdb_sql_database.main.name
  partition_key_path    = "/id"
  partition_key_version = 1
  default_ttl = 36000
  autoscale_settings {
    max_throughput = var.max_throughput
  }

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }

  /* unique_key {
    paths = ["/id"]
  } */
}

# Private DNS Zone for SQL API 
resource "azurerm_private_dns_zone" "this" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "${var.prefix}-private_dns_vnet_link_name"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.my_terraform_network.id
  registration_enabled  = false
}

resource "azurerm_private_endpoint" "example" {
  name                = "${var.prefix}-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.my_terraform_subnet_1.id

  private_service_connection {
    name                           = "${var.prefix}-privateserviceconnection"
    private_connection_resource_id = azurerm_cosmosdb_account.example.id
    subresource_names              = [ "SQL" ]
    is_manual_connection           = false
  }
}

/* resource "azurerm_private_endpoint" "example" {
  name                = "cosmosansuman-endpoint"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "cosmosansuman-privateserviceconnection"
    private_connection_resource_id = azurerm_cosmosdb_account.example.id
    subresource_names              = [ "SQL" ]
    is_manual_connection           = false
  }
} */

/* resource "azurerm_private_link_service" "example" {
  name                = "${var.prefix}-example-privatelink"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  nat_ip_configuration {
    name      = azurerm_public_ip.example.name
    primary   = true
    subnet_id = azurerm_subnet.my_terraform_network.id
  }

  load_balancer_frontend_ip_configuration_ids = [
    azurerm_lb.example.frontend_ip_configuration[0].id,
  ]
}

resource "azurerm_private_endpoint" "example" {
  name                = "${var.prefix}-example-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.my_terraform_network.id

  private_service_connection {
    name                           = "${var.prefix}-privateserviceconnection"
    private_connection_resource_id = azurerm_private_link_service.example.id
    is_manual_connection           = false
  }
} */