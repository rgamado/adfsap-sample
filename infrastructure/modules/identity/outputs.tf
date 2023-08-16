output "user_assigned_id" {
  value = azurerm_user_assigned_identity.uai.id
}

output "user_assigned_name" {
  value = azurerm_user_assigned_identity.uai.name
}

output "user_assigned_principal_id" {
  value = azurerm_user_assigned_identity.uai.principal_id
}