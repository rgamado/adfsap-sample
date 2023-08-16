output "storage_account_name" {
  value = azurerm_storage_account.datalake.name
}

output "adls_filesystem_ids" {
  value = tomap({
    for k, filesystem in azurerm_storage_data_lake_gen2_filesystem.filesystem : k => filesystem.id
  })
}

output "storage_account_id" {
  value = azurerm_storage_account.datalake.id
}

output "primary_dfs_endpoint" {
  value = azurerm_storage_account.datalake.primary_dfs_endpoint
}

output "table_storage_name" {
    value = azurerm_storage_table.watermark.name
}
