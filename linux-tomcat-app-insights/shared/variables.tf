variable "location" {
  type    = string
  default = "eastus"
}

variable "rg_name" {
  type = string
}

variable "la_sku" {
  type    = string
  default = "PerGB2018"
}

variable "suffix" {
  type    = string
  default = "cayers"
}

variable "action_group_name" {
  type    = string
  default = "cayers-tomcat-ag"
}