variable "service_name" {
  description = "The name of the Cloud Run service"
  type        = string
}

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Deployment region"
  type        = string
}

variable "image" {
  description = "Docker image path"
  type        = string
}

variable "port" {
  description = "Container port"
  type        = number
}

variable "service_account" {
  description = "Service Account name"
  type        = string
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "cloudsql_instance" {
  description = "Cloud SQL instance to connect"
  type        = string
}

variable "network_name" {
  description = "VPC network"
  type        = string
  default     = null
}

variable "subnet_name" {
  description = "VPC subnet"
  type        = string
  default     = null
}

variable "env_vars" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "ingress" {
  description = "sets the ingress settings for the Service"
  type        = string
}