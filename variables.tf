variable "resource_group_name" {
  default = "dotstat-rg"
}

variable "location" {
  default = "Canada Central"
}

variable "vm_name" {
  default = "dotstat-vm"
}

variable "vm_size" {
  default = "Standard_D2s_v5"
}

variable "admin_username" {
  default = "jalal"
}

variable "admin_password" {
  description = "Password for VM admin user"
  default     = "ChangeMe123!"
}
