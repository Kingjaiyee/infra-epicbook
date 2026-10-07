locals {
  vms = {
    frontend = { subnet_id = azurerm_subnet.frontend.id }
    backend  = { subnet_id = azurerm_subnet.backend.id }
  }
}

resource "azurerm_public_ip" "vm" {
  for_each            = local.vms
  name                = "${var.prefix}-${each.key}-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "vm" {
  for_each            = local.vms
  name                = "${var.prefix}-${each.key}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm[each.key].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = local.vms
  name                            = "${var.prefix}-${each.key}-vm"
  computer_name                   = "${var.prefix}-${each.key}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.vm[each.key].id]
  custom_data                     = base64encode(file("${path.module}/cloud-init.yaml"))

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${path.module}/${var.ssh_public_key_file}")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  boot_diagnostics {}

  depends_on = [
    azurerm_subnet_network_security_group_association.frontend,
    azurerm_subnet_network_security_group_association.backend,
  ]
}
