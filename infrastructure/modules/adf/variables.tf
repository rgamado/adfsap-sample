variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
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

variable "cmk_user_assigned_id" {
  type = string
}

variable "cmk_encryption_key_id" {
  type = string
}

variable "storage_account_id" {
    type = string
}

variable "git_account_name" {
    type = string
}

variable "git_branch_name" {
    type = string
}

variable "git_url" {
    type = string
}

variable "git_repository_name" {
    type = string
}

variable "git_root_folder" {
    type = string
    default = "/"
}
