resource "random_string" "mysql_suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_private_dns_zone" "mysql" {
  name                = "${var.prefix}.private.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "${var.prefix}-mysql-dns-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

resource "azurerm_mysql_flexible_server" "db" {
  name                              = "${var.prefix}-mysql-${random_string.mysql_suffix.result}"
  resource_group_name               = azurerm_resource_group.main.name
  location                          = azurerm_resource_group.main.location
  version                           = "8.0.21"
  sku_name                          = "B_Standard_B1ms"
  administrator_login               = var.db_admin_username
  administrator_password_wo         = var.db_admin_password
  administrator_password_wo_version = var.db_password_version
  delegated_subnet_id               = azurerm_subnet.database.id
  private_dns_zone_id               = azurerm_private_dns_zone.mysql.id
  backup_retention_days             = 1
  geo_redundant_backup_enabled      = false

  storage {
    size_gb = 20
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.mysql]

  lifecycle {
    ignore_changes = [zone]
  }
}
