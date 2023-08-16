resource "azurerm_user_assigned_identity" "uai" {
  location            = var.location
  name                = "uai-${var.default_name}"
  resource_group_name = var.resource_group_name
  tags = merge(
    var.tags,
    {
      BuildNumber = var.build_number
    },
  )
}