variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "name" {
  description = "Cloud Build name"
}

variable "location" {
  description = "Cloud Build location"
}

variable "branch_name" {
  description = "Cloud Build Branch name"
}

variable "repo_name" {
  description = "Cloud Build Repo name"
}

variable "repo_owner" {
  description = "Cloud Build Repo Owner"
}

variable "substitutions" {
  description = "Cloud Build substitutions"
}

variable "build_file_name" {
  description = "Cloud Build file name"
}
variable "service_account_name" {
  description = "service account name"
}