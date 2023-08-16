resource "azurerm_data_factory" "adf" {
  name                            = "df-${var.default_name}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  public_network_enabled          = false
  managed_virtual_network_enabled = true

  github_configuration {
    account_name    = var.git_account_name
    branch_name     = var.git_branch_name
    git_url         = var.git_url
    repository_name = var.git_repository_name
    root_folder     = var.git_root_folder
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.cmk_user_assigned_id]
  }

  customer_managed_key_id          = var.cmk_encryption_key_id
  customer_managed_key_identity_id = var.cmk_user_assigned_id

  tags = merge(
    var.tags,
    {
      BuildNumber = var.build_number
    },
  )

  lifecycle {
    ignore_changes = [
      identity,
      public_network_enabled,
      customer_managed_key_id,
      customer_managed_key_identity_id
    ]
  }
}

resource "azurerm_data_factory_managed_private_endpoint" "adf" {
  name               = "pe-storage-${var.default_name}"
  data_factory_id    = azurerm_data_factory.adf.id
  target_resource_id = var.storage_account_id
  subresource_name = "blob"
}