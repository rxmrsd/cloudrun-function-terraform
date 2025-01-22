variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The region for the network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "ip_range" {
  description = "CIDR range for the subnet"
  type        = string
}