terraform {
  backend "gcs" {
    bucket = "cloud-deployment-tf"
    prefix = "terraform/state"
  }
}