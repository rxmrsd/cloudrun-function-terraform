terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>5.13.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~>4"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "required_apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "iam.googleapis.com",
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudfunctions.googleapis.com",
  ])

  project = var.project_id
  service = each.key

  disable_dependent_services = false
  disable_on_destroy        = false
}

module "cloud_build" {
  source = "../../modules/cloud_build"

  name                 = var.build_name
  location             = var.build_region
  branch_name          = var.branch_name
  repo_name            = var.repo_name
  repo_owner           = var.repo_owner
  build_file_name      = var.build_file_name
  service_account_name = var.service_account_name
  project_id           = var.project_id
  substitutions        = var.substitutions

  depends_on = [
    google_project_service.required_apis
  ]
}

module "vpc_network" {
  source = "../../modules/vpc_network"

  network_name = var.network_name
  project_id   = var.project_id
  region       = var.region
  subnet_name  = var.direct_subnet_name
  ip_range     = var.direct_ip_range
  
}

module "backend_service" {
  source = "../../modules/cloud_run"

  service_name     = "${var.service_name}-backend"
  project_id       = var.project_id
  region           = var.region
  image            = "asia-northeast1-docker.pkg.dev/${var.project_id}/${var.service_name}/backend:${var.image_tag}"
  port             = 8080
  service_account  = "${var.service_account_name}@${var.project_id}.iam.gserviceaccount.com"
  min_instances    = 1
  ingress = "INGRESS_TRAFFIC_INTERNAL_ONLY"

  depends_on = [ 
    module.vpc_network
  ]
}

module "cloud_function_v2" {
  source              = "../../modules/cloud_run_function"
  project_id          = var.project_id
  region              = var.region
  function_name       = var.function_name
  function_description = "A new function"
  source_dir          = "../../../functions/"
  runtime             = "python311"
  entry_point         = "hello_get"
  bucket_location     = "US"
  max_instance_count  = 1
  available_memory    = "256M"
  timeout_seconds     = 60
  iam_role            = "roles/run.invoker"
  iam_member          = "allUsers"
  backend_url         = module.backend_service.service_url

  depends_on = [ 
    module.backend_service
  ]
}

resource "null_resource" "function-1-vpc-egress" {
  depends_on = [module.cloud_function_v2]

  triggers = {
    detached = "false"
    reapply = module.cloud_function_v2.function_uri
  }

  provisioner "local-exec" {
    command = "gcloud beta run services update ${var.function_name} --network=${var.network_name} --subnet=${var.direct_subnet_name} --network-tags=function-1 --vpc-egress all-traffic  --region ${var.region}"
  }
}