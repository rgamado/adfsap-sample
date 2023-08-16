resource "azurerm_storage_account" "datalake" {
  name                              = var.storage_account_name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  account_kind                      = "StorageV2"
  account_tier                      = "Standard"
  account_replication_type          = var.replication_type
  tags                              = var.tags
  is_hns_enabled                    = var.is_hns_enabled
  enable_https_traffic_only         = true
  public_network_access_enabled     = false
  allow_nested_items_to_be_public   = false
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled

  network_rules {
    default_action             = "Deny"
    bypass                     = ["Logging", "Metrics", "AzureServices"]
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }

  identity {
    type = "UserAssigned"
    identity_ids = [var.cmk_user_assigned_id]
  }

  customer_managed_key {
    user_assigned_identity_id = var.cmk_user_assigned_id
    key_vault_key_id          = var.cmk_encryption_key_id
  }

  lifecycle {
    ignore_changes = [
      identity,
      customer_managed_key,
      public_network_access_enabled,
      allow_nested_items_to_be_public,
      network_rules
    ]
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "filesystem" {
  for_each           = toset(var.adls_filesystems)
  name               = each.key
  storage_account_id = azurerm_storage_account.datalake.id
}

resource "azurerm_storage_table" "watermark" {
  name                 = "watermarktable"
  storage_account_name = azurerm_storage_account.datalake.name
}

resource "azurerm_private_endpoint" "datalake" {
  name                = "pe-storage-${var.default_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_storage_id

  private_service_connection {
    name                           = "psc-storage-${var.default_name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.datalake.id
    subresource_names              = ["blob"]
  }
}