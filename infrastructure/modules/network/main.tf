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

resource "azurerm_subnet" "private" {
  name                                          = "${var.default_name}-endpoint-subnet"
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.vnet.name
  address_prefixes                              = ["10.5.2.0/24"]
  private_endpoint_network_policies_enabled     = true

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_network_security_group" "vnet" {
	name                = "nsg-${var.default_name}"
	location            = var.location
	resource_group_name = var.resource_group_name

  tags = merge(
    var.tags,
    {
      BuildNumber = var.build_number
    },
  )
}

resource "azurerm_subnet_network_security_group_association" "vnet" {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.vnet.id
  depends_on = [
    azurerm_network_security_group.vnet,
    azurerm_subnet.default
  ]
}
