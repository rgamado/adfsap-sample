variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "adls_filesystems" {
  type    = list(string)
  default = []
}

variable "infrastructure_encryption_enabled" {
  type    = bool
  default = false
}

variable "tags" {}

variable "storage_account_name" {
  type = string
}

variable "is_hns_enabled" {
}

variable "replication_type" {
  type = string
}

variable "cmk_user_assigned_id" {
  type = string
}

variable "cmk_encryption_key_id" {
  type = string
}

variable "virtual_network_subnet_ids" {
  type    = list(string)
  default = []
  description = "Id list of subnets allowed to access the resource."
}

variable "private_endpoint_subnet_storage_id" {
  type = string
}

variable "default_name" {
  type = string
  description = "The Prefix or suffix used for all resources in this project."
}

variable "build_number" {
  type        = string
  default     = "local"
  description = "Build Number from Azure DevOps"
}