variable "resource_group_name" {
  type = string
  description = "Name of the resource group that the user assigned identity should be created."
}

variable "location" {
  type = string
  description = "The Azure Region in which all resources in this project should be created."
}

variable "default_name" {
  type = string
  description = "The Prefix or suffix used for all resources in this project."
}

variable "tags" {}

variable "build_number" {
  type        = string
  default     = "local"
  description = "Build Number from Azure DevOps"
}