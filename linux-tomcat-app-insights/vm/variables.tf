variable "location" {
  type    = string
  default = "eastus"
}

variable "rg_name" {
  type = string
}

variable "vm_suffix" {
  type    = string
  default = "cayers"
}

variable "vm_admin_user" {
  type    = string
  default = "adminuser"
}

variable "vm_size" {
  type    = string
  default = "Standard_D2d_v4"
}

variable "app_insights_conn_string" {
  type = string
}