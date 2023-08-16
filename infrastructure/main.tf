data "azurerm_client_config" "current" {}

locals {
  default_name = "ramadoanalytics"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags = merge(
    var.tags,
    {
      BuildNumber = var.build_number
    },
  )
}

resource "azurerm_role_assignment" "resource_group_contributor" {
  for_each             = toset(var.resource_group_contributors)
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = each.key
}

module "net" {
  source                 = "./modules/network"
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  default_name           = local.default_name
  tags                   = var.tags
}

module "managed_identity" {
  source                 = "./modules/identity"
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  default_name           = local.default_name
  tags                   = var.tags
}

module "key_vault" {
  source                                = "./modules/keyvault"
  location                              = azurerm_resource_group.rg.location
  resource_group_name                   = azurerm_resource_group.rg.name
  default_name                          = local.default_name
  user_assigned_identity_principal_id   = module.managed_identity.user_assigned_principal_id
  tags                                  = var.tags
}

module "data_storage" {
  source                             = "./modules/storage"
  location                           = azurerm_resource_group.rg.location
  resource_group_name                = azurerm_resource_group.rg.name
  default_name                       = local.default_name
  storage_account_name               = var.storage_account_name
  adls_filesystems                   = ["raw"]
  tags                               = var.tags
  is_hns_enabled                     = true
  replication_type                   = var.storage_replication_type
  cmk_user_assigned_id               = module.managed_identity.user_assigned_id
  cmk_encryption_key_id              = module.key_vault.key_vault_storage_cmk_id
  infrastructure_encryption_enabled  = var.storage_infrastructure_encryption_enabled
  private_endpoint_subnet_storage_id = module.net.subnet_private_endpoint_id
}

module "datafactory" {
  source                  = "./modules/adf"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  default_name            = local.default_name
  storage_account_id      = module.data_storage.storage_account_id
  cmk_user_assigned_id    = module.managed_identity.user_assigned_id
  cmk_encryption_key_id   = module.key_vault.key_vault_adf_cmk_id
  git_account_name        = var.adf_git_account_name
  git_branch_name         = var.adf_git_branch_name
  git_url                 = var.adf_git_url
  git_repository_name     = var.adf_git_repository_name
  git_root_folder         = var.adf_git_root_folder           
  tags                    = var.tags
}
