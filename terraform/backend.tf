# Remote state in Azure Storage. Entra ID auth only: the storage account has shared keys disabled.
terraform {
  backend "azurerm" {
    resource_group_name  = "epicbook-tfstate-rg"
    storage_account_name = "epicbooktf5d1628"
    container_name       = "tfstate"
    key                  = "epicbook.tfstate"
    use_azuread_auth     = true
  }
}
