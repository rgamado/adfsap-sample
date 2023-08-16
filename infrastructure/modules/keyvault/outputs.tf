output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}

output "key_vault_name" {
  value = azurerm_key_vault.kv.name
}

output "key_vault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}

output "key_vault_storage_cmk_id" {
    value = azurerm_key_vault_key.storage.id
}

output "key_vault_storage_cmk_name" {
    value = azurerm_key_vault_key.storage.name
}

output "key_vault_adf_cmk_id" {
    value = azurerm_key_vault_key.adf.id
}

output "key_vault_adf_cmk_name" {
    value = azurerm_key_vault_key.adf.name
}