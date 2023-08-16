data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                = "kv-${var.default_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  
  tags = merge(
    var.tags,
    {
      BuildNumber = var.build_number
    },
  )

  purge_protection_enabled        = true
  sku_name                        = "standard"
  soft_delete_retention_days      = 30
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  # public_network_access_enabled   = false

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }

  lifecycle {
    ignore_changes = [
      network_acls,
      public_network_access_enabled
    ]
  }
}

resource "azurerm_key_vault_access_policy" "client" {
  key_vault_id = azurerm_key_vault.kv.id
  object_id    = data.azurerm_client_config.current.object_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  key_permissions = [
    "Get",
    "List",
    "Create",
    "Update",
    "Delete",
    "Recover",
    "GetRotationPolicy"
  ]
}

resource "azurerm_key_vault_access_policy" "uai" {
  key_vault_id = azurerm_key_vault.kv.id
  object_id    = var.user_assigned_identity_principal_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  secret_permissions = [
     "Get", "List"
  ]
  
  key_permissions = [
    "UnwrapKey",
    "WrapKey",
    "Get"
  ]
}

resource "azurerm_key_vault_key" "storage" {
  key_vault_id = azurerm_key_vault.kv.id
  name         = "${var.default_name}-dl-cmk"
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  depends_on = [
    azurerm_key_vault_access_policy.uai
  ]
}

resource "azurerm_key_vault_key" "adf" {
  key_vault_id = azurerm_key_vault.kv.id
  name         = "${var.default_name}-adf-cmk"
  key_type     = "RSA"
  key_size     = 4096
  key_opts     = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  depends_on = [
    azurerm_key_vault_access_policy.uai
  ]
}

