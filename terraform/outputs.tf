# Exactly the four non-sensitive values the Application Repository needs
output "app_public_ip" {
  value = azurerm_public_ip.vm["frontend"].ip_address
}

output "backend_ansible_host" {
  value = azurerm_public_ip.vm["backend"].ip_address
}

output "backend_private_ip" {
  value = azurerm_network_interface.vm["backend"].private_ip_address
}

output "mysql_fqdn" {
  value = azurerm_mysql_flexible_server.db.fqdn
}
