variable "project_id" {
  description = "The ID of the GCP project."
  type        = string
}

variable "region" {
  description = "Region where the function will be deployed."
  type        = string
}

variable "function_name" {
  description = "Name of the Cloud Function."
  type        = string
}

variable "function_description" {
  description = "Description of the Cloud Function."
  type        = string
  default     = "A Cloud Function"
}

variable "source_dir" {
  description = "The directory containing the function source code."
  type        = string
}

variable "runtime" {
  description = "The runtime of the Cloud Function."
  type        = string
  default     = "python311"
}

variable "entry_point" {
  description = "The entry point of the Cloud Function."
  type        = string
}

variable "bucket_location" {
  description = "The location of the storage bucket."
  type        = string
  default     = "US"
}

variable "max_instance_count" {
  description = "Maximum number of instances for the Cloud Function."
  type        = number
  default     = 1
}

variable "available_memory" {
  description = "Available memory for the Cloud Function."
  type        = string
  default     = "256M"
}

variable "timeout_seconds" {
  description = "Timeout for the Cloud Function in seconds."
  type        = number
  default     = 60
}

variable "iam_role" {
  description = "IAM role to assign to the Cloud Function."
  type        = string
  default     = "roles/run.invoker"
}

variable "iam_member" {
  description = "IAM member to assign to the Cloud Function."
  type        = string
}

variable "backend_url" {
  description = "backend url"
  type        = string
}