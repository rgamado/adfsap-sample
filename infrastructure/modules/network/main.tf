resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.default_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.5.0.0/16"]

  tags = merge(
    var.tags,
    {
      BuildNumber = var.build_number
    },
  )
}

resource "azurerm_subnet" "default" {
  name                                          = "${var.default_name}-default-subnet"
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.vnet.name
  address_prefixes                              = ["10.5.1.0/24"]

  lifecycle {
    ignore_changes = all
  }
}
