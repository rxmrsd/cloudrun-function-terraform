variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The region for the resources"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "direct_subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "direct_ip_range" {
  description = "The IP range for the subnet"
  type        = string
}

variable "service_account_name" {
  description = "Service Account name"
  type        = string
}

variable "service_name" {
  description = "The name of the Cloud Run service"
  type        = string
}

variable "image_tag" {
  description = "Image tag"
  type        = string
  default = "latest"
}

variable "function_name" {
  description = "Cloud Run function name"
  type        = string
}

variable "build_name" {
  default = "xxx"
}

variable "build_region" {
  default = "us-central1"
}

variable "tag" {
  default = "latest"
}

variable "repo_owner" {
  description = "GitHub repository owner"
  type        = string
}

variable "repo_name" {
  description = "GitHub repository name"
  type        = string
}

variable "branch_name" {
  description = "GitHub branch name"
  type        = string
}

variable "substitutions" {
  description = "Cloud Build substitutions"
}

variable "build_file_name" {
  description = "Cloud Build file name"
}