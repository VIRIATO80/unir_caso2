variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "unir"
  description = "Prefix of the resource group name."
}

variable "linux_vm_name" {
  type        = string
  default     = "linux-vm"
  description = "Name of virtual machine."
}

variable "linux_vm_size" {
  type        = string
  default     = "Standard_DS2_v2"
  description = "Size of virtual machine."
}

variable "admin_username" {
  type        = string
  default     = "adminuser"
  description = "Name for admin user."
}

variable "ssh_public_key_path" {
  type        = string
  default     = "C:\\Users\\javil\\.ssh\\id_rsa.pub"
  description = "Public ssh key adress."
}