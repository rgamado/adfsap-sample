variable "resource_group_name" {
  type    = string
  default = "terrafrom"
}

variable "location" {
  type = string
}

variable "resource_group_contributors" {
  type        = list(string)
  description = "List of Object IDs of AAD principals / groups to be given contribute access to the RG"
  default     = []
}

variable "tags" {
  default = {
    "ProjectName" = "TERRAFROM"
  }
}

variable "build_number" {
  type        = string
  default     = "local"
  description = "Build Number from Azure DevOps"
}

variable "storage_replication_type" {
  type     = string
  default  = "ZRS"
}

variable "storage_infrastructure_encryption_enabled" {
  type    = bool
  default = false
}

variable "storage_account_name" {
  type     = string
}

variable "adf_git_account_name" {
  type     = string
}

variable "adf_git_branch_name" {
  type     = string
  default = "main"
}

variable "adf_git_url" {
  type     = string
}

variable "adf_git_repository_name" {
  type     = string
}

variable "adf_git_root_folder" {
  type     = string
}
