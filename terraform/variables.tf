variable "location" {
  type    = string
  default = "swedencentral"
}

variable "prefix" {
  type    = string
  default = "epicbook"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key_file" {
  type        = string
  description = "Public key Ansible uses to reach both VMs, relative to this folder"
  default     = "keys/epicbook_ansible_ed25519.pub"
}

variable "backend_app_port" {
  type    = number
  default = 8080
}

variable "admin_cidr" {
  type        = string
  description = "My home IP as a /32. Comes from a secret pipeline variable, never from Git."
  sensitive   = true

  validation {
    condition     = can(cidrhost(var.admin_cidr, 0)) && endswith(var.admin_cidr, "/32")
    error_message = "admin_cidr must be a single IPv4 address in /32 form."
  }
}

variable "agent_cidr" {
  type        = string
  description = "The Azure DevOps self-hosted agent's public IP as a /32"

  validation {
    condition     = can(cidrhost(var.agent_cidr, 0)) && endswith(var.agent_cidr, "/32")
    error_message = "agent_cidr must be a single IPv4 address in /32 form."
  }
}

variable "db_admin_username" {
  type      = string
  sensitive = true
}

# Ephemeral and write-only: never stored in the plan file or the state
variable "db_admin_password" {
  type      = string
  sensitive = true
  ephemeral = true
}

variable "db_password_version" {
  type        = number
  description = "Increase by one to push a new MySQL admin password"
  default     = 1
}
